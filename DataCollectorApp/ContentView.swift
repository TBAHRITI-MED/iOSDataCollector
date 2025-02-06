import SwiftUI
import Combine
import MapKit

struct ContentView: View {
    
    // Managers
    @StateObject private var locationManager = LocationManager()
    @StateObject private var motionManager = MotionManager()
    @StateObject private var networkManager = ConnectivityManager()
    @StateObject private var sensorManager = SensorManager()
    @StateObject private var batteryManager = BatteryManager()
    
    // Data Logger
    private var dataLogger = DataLogger()
    
    // Pour gérer le timer
    @State private var collectionTimer: Timer?
    
    // Pour savoir si on enregistre ou pas
    @State private var isCollecting = false
    
    // Région de la carte
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Data Collector")
                .font(.title)
            
            // Bouton d’autorisation Localisation
            Button(action: {
                locationManager.requestAuthorization()
            }) {
                Text("Autoriser la localisation")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // Carte
            Map(coordinateRegion: $region, showsUserLocation: true)
                .frame(height: 250)
                .onReceive(locationManager.$currentLocation) { newLocation in
                    guard let loc = newLocation else { return }
                    region.center = loc.coordinate
                }
            
            // Affichage des données
            Text("Location: \(locationText)")
            Text("Speed: \(String(format: "%.2f", locationManager.currentSpeed)) m/s")
            Text("Acceleration: x=\(motionManager.accelerationX, specifier: "%.2f"), y=\(motionManager.accelerationY, specifier: "%.2f"), z=\(motionManager.accelerationZ, specifier: "%.2f")")
            Text("Humidity: \(sensorManager.humidity ?? 0, specifier: "%.2f")%")
            Text("Temperature: \(sensorManager.temperature ?? 0, specifier: "%.2f")°C")
            Text("Network: \(networkInfo)")
            Text("Battery: \((batteryManager.batteryLevel * 100), specifier: "%.0f")% (\(batteryManager.batteryStateDescription))")
            
            // Boutons Start/Stop + Export
            HStack {
                Button(action: {
                    if isCollecting {
                        stopCollecting()
                    } else {
                        startCollecting()
                    }
                }) {
                    Text(isCollecting ? "Stop" : "Start")
                        .padding()
                        .background(isCollecting ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button("Export CSV") {
                    exportCSV()
                }
                
                Button("Export JSON") {
                    exportJSON()
                }
            }
        }
        .padding()
        .onAppear {
            // Mettre à jour le type de réseau, etc.
            // (networkManager et batteryManager se mettent à jour automatiquement)
        }
    }
    
    // MARK: - Helpers
    
    private var locationText: String {
        if let loc = locationManager.currentLocation {
            return String(format: "%.4f, %.4f (alt: %.1f)",
                          loc.coordinate.latitude,
                          loc.coordinate.longitude,
                          loc.altitude)
        }
        return "Unknown"
    }
    
    private var networkInfo: String {
        if networkManager.isWifi {
            return "Wi-Fi - \(networkManager.carrierName)"
        } else {
            return "\(networkManager.networkType) - \(networkManager.carrierName)"
        }
    }
    
    // MARK: - Collecte des données
    
    private func startCollecting() {
        isCollecting = true
        
        // Démarrer les managers
        locationManager.startUpdatingLocation()
        motionManager.startUpdates()
        sensorManager.startSimulating()
        // batteryManager se met à jour tout seul
        // networkManager se met à jour tout seul
        
        // Timer pour collecter à une fréquence donnée (ex : 100 Hz)
        collectionTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            collectData()
        })
    }
    
    private func stopCollecting() {
        isCollecting = false
        locationManager.stopUpdatingLocation()
        motionManager.stopUpdates()
        sensorManager.stopSimulating()
        collectionTimer?.invalidate()
        collectionTimer = nil
    }
    
    /// Ajoute une nouvelle ligne de mesures au DataLogger
    private func collectData() {
        let now = Date()
        
        // Localisation
        let lat = locationManager.currentLocation?.coordinate.latitude ?? 0
        let lon = locationManager.currentLocation?.coordinate.longitude ?? 0
        let alt = locationManager.currentLocation?.altitude ?? 0
        let spd = locationManager.currentSpeed
        
        // Accélération
        let ax = motionManager.accelerationX
        let ay = motionManager.accelerationY
        let az = motionManager.accelerationZ
        
        // Humidité / Température
        let hum = sensorManager.humidity
        let temp = sensorManager.temperature
        
        // Réseau
        let netSignal = networkInfo  // ex. "Wi-Fi - Orange" ou "4G - SFR"
        
        // Batterie
        let batLvl = batteryManager.batteryLevel
        let batSt  = batteryManager.batteryStateDescription
        
        let data = SensorData(
            timestamp: now,
            latitude: lat,
            longitude: lon,
            altitude: alt,
            speed: spd,
            accelerationX: ax,
            accelerationY: ay,
            accelerationZ: az,
            humidity: hum,
            temperature: temp,
            networkSignal: netSignal,
            batteryLevel: batLvl,
            batteryState: batSt
        )
        
        dataLogger.addData(data)
    }
    
    // MARK: - Export
    
    private func exportCSV() {
        guard let csvURL = dataLogger.exportAsCSV() else { return }
        presentShareSheet(url: csvURL)
    }
    
    private func exportJSON() {
        guard let jsonURL = dataLogger.exportAsJSON() else { return }
        presentShareSheet(url: jsonURL)
    }
    
    private func presentShareSheet(url: URL) {
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(av, animated: true, completion: nil)
        }
    }
}
