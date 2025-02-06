import CoreMotion
import Combine

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    
    @Published var accelerationX: Double = 0
    @Published var accelerationY: Double = 0
    @Published var accelerationZ: Double = 0
    
    // Fréquence d'échantillonnage
    private let updateInterval = 0.01  // 100 Hz
    
    func startUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] data, _ in
            guard let self = self, let data = data else { return }
            self.accelerationX = data.acceleration.x
            self.accelerationY = data.acceleration.y
            self.accelerationZ = data.acceleration.z
        }
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
}
