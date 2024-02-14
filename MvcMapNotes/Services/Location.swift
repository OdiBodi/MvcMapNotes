import CoreLocation
import Combine

class Location: NSObject {
    private var manager = CLLocationManager()

    private let locationSubject = PassthroughSubject<CLLocation, Never>()

    var updatingLocation: Bool = false {
        didSet {
            updatingLocation ? manager.startUpdatingLocation() : manager.stopUpdatingLocation()
        }
    }

    override init() {
        super.init()
        manager.delegate = self
    }
}

// MARK: - Publishers

extension Location {
    var location: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
    }
}

// MARK: - Authorization

extension Location {
    func requestAuthorization() {
        guard manager.authorizationStatus == .authorizedWhenInUse else {
            return
        }
        manager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate

extension Location: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        locationSubject.send(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location: fail error: \(error.localizedDescription)")
    }
}
