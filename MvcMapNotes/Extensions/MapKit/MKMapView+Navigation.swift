import MapKit

extension MKMapView {
    func setCenter(_ coordinate: CLLocationCoordinate2D, withOffset offset: CGPoint) {
        let point = self.convert(coordinate, toPointTo: self) + offset
        let center = self.convert(point, toCoordinateFrom: self)
        self.setCenter(center, animated: true)
    }
}
