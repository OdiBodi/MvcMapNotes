import MapKit
import Combine

class DetailViewController: BaseCoordinatorModule<DetailModuleCompletion, Never> {
    private var subscriptions = Set<AnyCancellable>()

    private var model: DetailModel?
}

// MARK: - Initializators

extension DetailViewController {
    func initialize(model: DetailModel, view: DetailView) {
        self.model = model
        self.view = view
    }
}

// MARK: - Note

extension DetailViewController {
    func note(id: Int) -> NoteModel? {
        model?.note(id: id)
    }

    func addNote(coordinate: CLLocationCoordinate2D) {
        guard let model else {
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
