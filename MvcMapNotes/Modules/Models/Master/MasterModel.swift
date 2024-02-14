import Combine

class MasterModel {
    private let notesUpdatedSubject = PassthroughSubject<[NoteModel], Never>()
}

// MARK: - Publishers

extension MasterModel {
    var notesUpdated: AnyPublisher<[NoteModel], Never> {
        Notes.shared.$notes.eraseToAnyPublisher()
    }
}

// MARK: - Notes

extension MasterModel {
    func removeNote(id: Int) {
        let notes = Notes.shared
        guard let note = notes.note(id: id) else {
            return
        }
        notes.removeNote(model: note)
    }
}
