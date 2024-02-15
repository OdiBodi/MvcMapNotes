import Foundation
import Combine
import UIKit

class Notes {
    @Published var notes: [NoteModel] = []
}

// MARK: - Static

extension Notes {
    static let shared = Notes()
}

// MARK: - Synchronization

extension Notes {
    @discardableResult
    func load() -> Bool {
        guard let url = url() else {
            return false
        }

        do {
            let data = try Data(contentsOf: url)
            let model = try JSONDecoder().decode(NotesModel.self, from: data)
            notes = model.notes
            return true
        } catch {
            print("Notes: load error: \(error)")
        }

        return false
    }

    @discardableResult
    func save() -> Bool {
        do {
            let model = NotesModel(notes: notes)
            let data = try JSONEncoder().encode(model)

            guard let url = url() else {
                return false
            }

            try data.write(to: url)
        } catch {
            print("Notes: save error: \(error)")
        }

        return true
    }
}

// MARK: - Helpers

extension Notes {
    func note(id: Int) -> NoteModel? {
        notes.first { $0.id == id }
    }

    func addNote(model: NoteModel) {
        guard note(id: model.id) == nil else {
            return
        }
        notes.append(model)
    }

    func removeNote(model: NoteModel) {
        notes.removeAll { $0.id == model.id }
    }

    func updateNote(id: Int, color: UIColor? = nil, text: String? = nil) {
        guard let index = notes.firstIndex(where: { $0.id == id }) else {
            return
        }
        let note = notes[index]
        notes[index] = NoteModel(coordinate: note.coordinate,
                                 color: color ?? note.color,
                                 text: text ?? note.text)
    }

    private func url() -> URL? {
        do {
            let cachesUrl = try FileManager.default.url(for: .cachesDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: true)
            return cachesUrl.appendingPathComponent("notes")
        } catch {
            print("Notes: url error: \(error.localizedDescription)")
        }
        return nil
    }
}
