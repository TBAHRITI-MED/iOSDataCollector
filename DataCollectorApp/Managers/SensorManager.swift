import Foundation
import Combine

class SensorManager: ObservableObject {
    @Published var humidity: Double? = nil
    @Published var temperature: Double? = nil
    
    private var timer: Timer?
    
    func startSimulating() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // Valeurs aléatoires
            self.humidity = Double.random(in: 40...60)
            self.temperature = Double.random(in: 20...30)
        }
    }
    
    func stopSimulating() {
        timer?.invalidate()
        timer = nil
    }
}
