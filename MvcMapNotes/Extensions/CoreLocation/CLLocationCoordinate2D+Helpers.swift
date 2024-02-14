import CoreLocation

extension CLLocationCoordinate2D {
    func point() -> CGPoint {
        CGPoint(x: self.latitude, y: self.longitude)
    }
}
