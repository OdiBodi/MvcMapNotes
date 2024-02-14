import MapKit

extension MKMapView {
    func toggleZoom() {
        self.isZoomEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isZoomEnabled = true
        }
    }
}
