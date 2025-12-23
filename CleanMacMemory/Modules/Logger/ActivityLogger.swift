import Foundation

class ActivityLogger {
    private var logs: [String] = []
    private let maxLogs = 50
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
    }
    
    /// Logs an action with timestamp
    func log(_ message: String) {
        let timestamp = dateFormatter.string(from: Date())
        let logEntry = "[\(timestamp)] \(message)"
        
        DispatchQueue.main.async {
            self.logs.append(logEntry)
            
            // Keep only the most recent logs
            if self.logs.count > self.maxLogs {
                self.logs.removeFirst()
            }
        }
    }
    
    /// Returns the most recent logs
    func getRecentLogs() -> [String] {
        return Array(logs.reversed())
    }
    
    /// Clears all logs
    func clearLogs() {
        logs.removeAll()
    }
    
    /// Exports logs to a file
    func exportLogs(to url: URL) throws {
        let logContent = logs.joined(separator: "\n")
        try logContent.write(to: url, atomically: true, encoding: .utf8)
    }
}
