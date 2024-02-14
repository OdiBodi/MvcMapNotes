import Combine
import MapKit

class DetailView: UIView {
    private lazy var mapView = initializeMapView()

    private weak var controller: DetailViewController?

    private var subscriptions: Set<AnyCancellable> = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Life cycle

extension DetailView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Initializators

extension DetailView {
    func initialize(model: DetailModel, controller: DetailViewController) {
        mapView.region = model.mapRegion
        self.controller = controller
        subscribeOnModel(model)
    }
}

// MARK: - Subscriptions

extension DetailView {
    private func subscribeOnModel(_ model: DetailModel) {
        subscribeOnModelNoteUpdated(model)
        subscribeOnModelNotesUpdated(model)
    }

    private func subscribeOnModelNoteUpdated(_ model: DetailModel) {
        model.noteSelected.sink { [weak self] note in
            guard let mapView = self?.mapView else {
                return
            }

            if let note = note {
                let selectedAnnotation = self?.selectedAnnotation(by: note)

                guard selectedAnnotation == nil else {
                    return
                }

                guard let annotation = self?.annotation(by: note) else {
                    return
                }

                DispatchQueue.main.async {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            } else {
                mapView.selectedAnnotations.forEach {
                    mapView.deselectAnnotation($0, animated: true)
                }
            }
        }.store(in: &subscriptions)
    }

    private func subscribeOnModelNotesUpdated(_ model: DetailModel) {
        model.notesUpdated.sink { [weak self] (oldNotes, newNotes) in
            guard let mapView = self?.mapView else {
                return
            }

            let otherNotes = mapView.annotations.isEmpty ? [] : oldNotes
            let notes = newNotes.difference(from: otherNotes) { $0.id == $1.id }

            if notes.isEmpty {
                newNotes.forEach { [weak self] in
                    guard let annotation = self?.annotation(by: $0),
                          annotation.color != $0.color || annotation.text != $0.text,
                          let annotationView = mapView.view(for: annotation) as? NoteAnnotationView else {
                        return
                    }
                    annotation.color = $0.color
                    annotation.text = $0.text
                    annotationView.initialize(note: annotation)
                }
            } else {
                for change in notes {
                    switch change {
                    case let .insert(_, note, _):
                        let annotation = NoteAnnotation(id: note.id,
                                                        coordinate: note.locationCoordinate,
                                                        color: note.color,
                                                        text: note.text)
                        mapView.addAnnotation(annotation)
                    case let .remove(_, note, _):
                        guard let annotation = self?.annotation(by: note) else {
                            break
                        }
                        mapView.removeAnnotation(annotation)
                    }
                }
            }
        }.store(in: &subscriptions)
    }
}

// MARK: - Subviews

extension DetailView {
    private func initializeMapView() -> MKMapView {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.delegate = self
        view.register(NoteAnnotationView.self, forAnnotationViewWithReuseIdentifier: NoteAnnotationView.id)
        view.register(NoteClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: NoteClusterAnnotationView.id)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onMapTapped))
        view.addGestureRecognizer(tapGesture)

        return view
    }

    private func addSubviews() {
        addSubview(mapView)
    }

    private func updateSubviewsConstraints() {
        mapView.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Helpers

extension DetailView {
    private func selectedAnnotations(by location: CGPoint) -> [MKAnnotation] {
        let annotations = mapView.annotations.filter {
            guard let annotationView = mapView.view(for: $0) else {
                return false
            }
            let frame = annotationView.frame
            let insetFrame = frame.insetBy(dx: -10, dy: -10)
            return insetFrame.contains(location)
        }
        return annotations
    }

    private func selectedAnnotation(by note: NoteModel) -> NoteAnnotation? {
        mapView.selectedAnnotations.first { ($0 as? NoteAnnotation)?.id == note.id } as? NoteAnnotation
    }

    private func annotation(by note: NoteModel) -> NoteAnnotation? {
        mapView.annotations.first { ($0 as? NoteAnnotation)?.id == note.id } as? NoteAnnotation
    }
}

// MARK: - MKMapViewDelegate

extension DetailView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let noteAnnotation = annotation as? NoteAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: NoteAnnotationView.id,
                                                             for: annotation) as! NoteAnnotationView
            view.initialize(note: noteAnnotation)
            return view
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: NoteClusterAnnotationView.id,
                                                             for: annotation) as! NoteClusterAnnotationView

            let numberAnnotations = clusterAnnotation.memberAnnotations.count
            view.initialize(number: numberAnnotations)

            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        if let noteAnnotation = annotation as? NoteAnnotation {
            let yOffset = bounds.height / 4
            mapView.setCenter(annotation.coordinate, withOffset: CGPoint(x: 0, y: yOffset))
            controller?.openNote(id: noteAnnotation.id)
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            let region = clusterAnnotation.region(withZoom: 2)
            mapView.setRegion(region, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        controller?.updateMapRegion(region: mapView.region)
    }
}

// MARK: - Callbacks

extension DetailView {
    @objc private func onMapTapped(gestureRecognizer: UITapGestureRecognizer) {
        mapView.toggleZoom()

        guard mapView.selectedAnnotations.isEmpty else {
            return
        }

        let location = gestureRecognizer.location(in: mapView)
        guard selectedAnnotations(by: location).isEmpty else {
            return
        }

        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        controller?.addNote(coordinate: coordinate)
    }
}
