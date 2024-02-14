import MapKit
import Combine

class DetailViewController: BaseCoordinatorModule<DetailModuleCompletion, Never> {
    private var subscriptions = Set<AnyCancellable>()

    private var model: DetailModel?
}

// MARK: - Life cycle

extension DetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

// MARK: - Initializators

extension DetailViewController {
    func initialize(model: DetailModel, view: DetailView) {
        self.model = model
        self.view = view
    }
}

// MARK: - Configurators

extension DetailViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Note

extension DetailViewController {
    func note(id: Int) -> NoteModel? {
        model?.note(id: id)
    }

    func addNote(coordinate: CLLocationCoordinate2D) {
        guard let model = model else {
            return
        }
        let noteModel = NoteModel(coordinate: coordinate.point(), color: .random(), text: "")
        model.addNote(model: noteModel)
        model.selectedNote = noteModel
    }

    func removeNote(id: Int) {
        guard let note = note(id: id) else {
            return
        }
        model?.removeNote(model: note)
    }

    func openNote(id: Int) {
        completionSubject.send(.openNoteDetails(id: id))
    }

    func selectNote(id: Int) {
        guard let note = note(id: id) else {
            return
        }
        model?.selectedNote = note
    }
}

// MARK: - Map

extension DetailViewController {
    func updateMapRegion(region: MKCoordinateRegion) {
        model?.mapRegion = region
    }
}