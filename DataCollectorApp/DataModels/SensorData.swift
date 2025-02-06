import Foundation

struct SensorData: Codable {
    let timestamp: Date
    
    // Localisation
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let speed: Double
    
    // Accélération
    let accelerationX: Double
    let accelerationY: Double
    let accelerationZ: Double
    
    // Capteurs fictifs / hum. & temp.
    let humidity: Double?
    let temperature: Double?
    
    // Réseau (type, opérateur, etc.)
    let networkSignal: String?
    
    // Batterie
    let batteryLevel: Float?
    let batteryState: String?
    let motionActivity: String?  // ex. "Walking", "Running", "Driving", etc.
}
