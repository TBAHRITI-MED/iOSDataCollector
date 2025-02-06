import Foundation
import Combine
import UIKit

class BatteryManager: ObservableObject {
    @Published var batteryLevel: Float = -1
    @Published var batteryState: UIDevice.BatteryState = .unknown
    
    init() {
        // Activer la surveillance de la batterie
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // Observer les notifications système
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        
        updateBatteryInfo()
    }
    
    @objc private func batteryLevelDidChange(_ notification: Notification) {
        updateBatteryInfo()
    }
    
    @objc private func batteryStateDidChange(_ notification: Notification) {
        updateBatteryInfo()
    }
    
    private func updateBatteryInfo() {
        batteryLevel = UIDevice.current.batteryLevel  // [0 ... 1] ou -1 si inconnu
        batteryState = UIDevice.current.batteryState
    }
}

extension BatteryManager {
    // Pour un affichage plus lisible
    var batteryStateDescription: String {
        switch batteryState {
        case .charging: return "En charge"
        case .full:     return "Pleine"
        case .unplugged:return "Débranchée"
        default:        return "Inconnu"
        }
    }
}
