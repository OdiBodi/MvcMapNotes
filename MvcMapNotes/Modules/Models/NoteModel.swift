import MapKit

struct NoteModel: Codable {
    let coordinate: CGPoint
    @HexCodableColor var color: UIColor
    let text: String
}

// MARK: - Helpers

extension NoteModel {
    var id: Int {
        coordinate.x.hashValue ^ coordinate.y.hashValue
    }

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinate.x, longitude: coordinate.y)
    }
}
