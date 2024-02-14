import MapKit

extension MKCoordinateRegion {
    @discardableResult
    mutating func fromUserDefaults(key: String) -> Bool {
        guard let region = UserDefaults.standard.object(forKey: key) as? [String: CLLocationDegrees] else {
            return false
        }

        self.center = CLLocationCoordinate2D(latitude: region["latitude"] ?? 0,
                                             longitude: region["longitude"] ?? 0)
        self.span = MKCoordinateSpan(latitudeDelta: region["latitude_delta"] ?? 0,
                                     longitudeDelta: region["longitude_delta"] ?? 0)

        return true
    }

    func toUserDefaults(key: String) {
        let region = [
            "latitude": center.latitude,
            "longitude": center.longitude,
            "latitude_delta": span.latitudeDelta,
            "longitude_delta": span.longitudeDelta
        ]
        UserDefaults.standard.set(region, forKey: key)
    }
}
