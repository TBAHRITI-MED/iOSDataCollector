import CoreTelephony
import Network
import Combine

class ConnectivityManager: ObservableObject {
    private let telephonyInfo = CTTelephonyNetworkInfo()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var networkType: String = "Unknown"
    @Published var carrierName: String = "Unknown carrier"
    @Published var isWifi: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isWifi = path.usesInterfaceType(.wifi)
                self?.updateRadioType()
            }
        }
        monitor.start(queue: queue)
        
        updateRadioType()
    }
    
    private func updateRadioType() {
        // Nom de l’opérateur
        if let provider = telephonyInfo.serviceSubscriberCellularProviders?.values.first {
            carrierName = provider.carrierName ?? "Unknown carrier"
        } else {
            carrierName = "No SIM"
        }
        
        // Type de radio
        if let radioTech = telephonyInfo.serviceCurrentRadioAccessTechnology?.values.first {
            networkType = readableRadioTech(radioTech)
        } else {
            // Peut-être Wi-Fi
            networkType = isWifi ? "Wi-Fi" : "Unknown"
        }
    }
    
    private func readableRadioTech(_ radioTech: String) -> String {
        switch radioTech {
        case CTRadioAccessTechnologyLTE:
            return "4G"
        case CTRadioAccessTechnologyNR, CTRadioAccessTechnologyNRNSA:
            return "5G"
        case CTRadioAccessTechnologyWCDMA:
            return "3G"
        case CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyGPRS:
            return "2G"
        default:
            return radioTech
        }
    }
}
