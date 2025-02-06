import CoreMotion
import Combine

class ActivityManager: ObservableObject {
    private let activityManager = CMMotionActivityManager()
    
    // Activité courante (ex. "Walking", "Running", "Driving", "Unknown")
    @Published var currentActivity: String = "Unknown"
    
    func startUpdates() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            currentActivity = "Not Available"
            return
        }
        
        // On reçoit des mises à jour en temps réel
        activityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] activity in
            guard let self = self, let activity = activity else { return }
            DispatchQueue.main.async {
                self.currentActivity = self.interpret(activity)
            }
        }
    }
    
    func stopUpdates() {
        activityManager.stopActivityUpdates()
    }
    
    private func interpret(_ activity: CMMotionActivity) -> String {
        if activity.automotive == true {
            return "Driving"
        } else if activity.running == true {
            return "Running"
        } else if activity.walking == true {
            return "Walking"
        } else if activity.cycling == true {
            return "Cycling"
        } else if activity.stationary == true {
            return "Stationary"
        }
        return "Unknown"
    }
}
