import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var currentSpeed: Double = 0  // En m/s
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // On peut demander ici l'autorisation, ou via un bouton
        // locationManager.requestAlwaysAuthorization()
    }
    
    func requestAuthorization() {
        // "Always" ou "When In Use" selon vos besoins
        locationManager.requestAlwaysAuthorization()
        // locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("Localisation Always autorisée.")
        case .authorizedWhenInUse:
            print("Localisation When In Use autorisée.")
        case .denied, .restricted:
            print("Localisation refusée ou restreinte.")
        case .notDetermined:
            print("L'utilisateur n'a pas encore choisi.")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        currentLocation = newLocation
        
        let spd = newLocation.speed
        currentSpeed = spd >= 0 ? spd : 0
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erreur de localisation: \(error)")
    }
}
