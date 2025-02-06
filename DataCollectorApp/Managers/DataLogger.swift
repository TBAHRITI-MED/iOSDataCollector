import Foundation

class DataLogger {
    private var dataBuffer: [SensorData] = []
    
    func addData(_ data: SensorData) {
        dataBuffer.append(data)
    }
    
    func clear() {
        dataBuffer.removeAll()
    }
    
    // MARK: - Export en CSV
    func exportAsCSV() -> URL? {
        var csvText = "Timestamp,Latitude,Longitude,Altitude,Speed,AccelerationX,AccelerationY,AccelerationZ,Humidity,Temperature,Network,BatteryLevel,BatteryState\n"
        
        let dateFormatter = ISO8601DateFormatter()
        
        for record in dataBuffer {
            let timestampStr = dateFormatter.string(from: record.timestamp)
            let line = """
            \(timestampStr),\
            \(record.latitude),\
            \(record.longitude),\
            \(record.altitude),\
            \(record.speed),\
            \(record.accelerationX),\
            \(record.accelerationY),\
            \(record.accelerationZ),\
            \(record.humidity ?? 0),\
            \(record.temperature ?? 0),\
            \(record.networkSignal ?? "Unknown"),\
            \(record.batteryLevel ?? -1),\
            \(record.batteryState ?? "Unknown")
            """
            csvText.append(line + "\n")
        }
        
        // Enregistrement dans un fichier temporaire
        let fileName = "sensor_data_\(Date().timeIntervalSince1970).csv"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try csvText.write(to: tempURL, atomically: true, encoding: .utf8)
            return tempURL
        } catch {
            print("Erreur d'écriture du CSV : \(error)")
            return nil
        }
    }
    
    // MARK: - Export en JSON
    func exportAsJSON() -> URL? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(dataBuffer)
            let fileName = "sensor_data_\(Date().timeIntervalSince1970).json"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try jsonData.write(to: tempURL)
            return tempURL
        } catch {
            print("Erreur d'écriture du JSON : \(error)")
            return nil
        }
    }
}
