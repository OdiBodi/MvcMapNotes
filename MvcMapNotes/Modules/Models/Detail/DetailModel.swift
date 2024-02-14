import Combine
import UIKit
import MapKit
import SwiftUI

class DetailModel {
    private let noteSelectedSubject = CurrentValueSubject<NoteModel?, Never>(nil)
}

// MARK: - Map

extension DetailModel {
    var mapRegion: MKCoordinateRegion {
        get {
            var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                                            span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06))
            region.fromUserDefaults(key: "map_region")
            return region
        }
        set {
            newValue.toUserDefaults(key: "map_region")
        }
    }
}

// MARK: - Publishers

extension DetailModel {
    var notesUpdated: AnyPublisher<(oldNotes: [NoteModel], newNotes: [NoteModel]), Never> {
        Notes.shared.$notes.map { (Notes.shared.notes, $0) }.eraseToAnyPublisher()
    }

    var noteSelected: AnyPublisher<NoteModel?, Never> {
        noteSelectedSubject.eraseToAnyPublisher()
    }
}

// MARK: - Notes

extension DetailModel {
    var selectedNote: NoteModel? {
        get {
            noteSelectedSubject.value
        }
        set {
            noteSelectedSubject.send(newValue)
        }
    }

    var notes: [NoteModel] {
        Notes.shared.notes
    }

    func note(id: Int) -> NoteModel? {
        Notes.shared.note(id: id)
    }

    func addNote(model: NoteModel) {
        Notes.shared.addNote(model: model)
    }

    func removeNote(model: NoteModel) {
        Notes.shared.removeNote(model: model)
    }

    func updateNote(id: Int, color: UIColor? = nil, text: String? = nil) {
        Notes.shared.updateNote(id: id, color: color, text: text)
    }
}
