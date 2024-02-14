import MapKit

class NoteAnnotation: NSObject, MKAnnotation {
    let id: Int
    let coordinate: CLLocationCoordinate2D
    var color: UIColor
    var text: String

    init(id: Int, coordinate: CLLocationCoordinate2D, color: UIColor, text: String) {
        self.id = id
        self.coordinate = coordinate
        self.color = color
        self.text = text
    }
}
