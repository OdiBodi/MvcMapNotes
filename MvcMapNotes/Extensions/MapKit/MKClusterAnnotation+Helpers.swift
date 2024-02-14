import MapKit

extension MKClusterAnnotation {
    func region(withZoom zoom: Double = 1) -> MKCoordinateRegion {
        var minLatitude = Double.infinity
        var maxLatitude = -Double.infinity
        var minLongitude = Double.infinity
        var maxLongitude = -Double.infinity

        self.memberAnnotations.forEach {
            let coordinate = $0.coordinate
            minLatitude = min(minLatitude, coordinate.latitude)
            maxLatitude = max(maxLatitude, coordinate.latitude)
            minLongitude = min(minLongitude, coordinate.longitude)
            maxLongitude = max(maxLongitude, coordinate.longitude)
        }

        let centerLatitude = (minLatitude + maxLatitude) / 2
        let centerLongitude = (minLongitude + maxLongitude) / 2
        let latitudeDelta = maxLatitude - minLatitude
        let longitudeDelta = maxLongitude - minLongitude

        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta * zoom, longitudeDelta: longitudeDelta * zoom)
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let region = MKCoordinateRegion(center: center, span: span)

        return region
    }
}
