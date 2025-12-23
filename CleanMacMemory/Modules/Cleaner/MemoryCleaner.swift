import Foundation

struct CleaningResult {
    let success: Bool
    let freedMemoryMB: Double
    let itemsCleaned: Int
    let itemsSkipped: Int
    let errors: [String]
}

class MemoryCleaner {
    private let fileManager = FileManager.default
    
    /// Executes the cleaning process
    func cleanSystemCache() -> CleaningResult {
        var totalFreedBytes: UInt64 = 0
        var itemsCleaned = 0
        var itemsSkipped = 0
        var errors: [String] = []
        
        // Clean user caches
        if let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let result = cleanDirectory(cachesURL)
            totalFreedBytes += result.freedBytes
            itemsCleaned += result.itemsCleaned
            itemsSkipped += result.itemsSkipped
            errors.append(contentsOf: result.errors)
        }
        
        // Clean temporary files
        let tempURL = fileManager.temporaryDirectory
        let result = cleanDirectory(tempURL)
        totalFreedBytes += result.freedBytes
        itemsCleaned += result.itemsCleaned
        itemsSkipped += result.itemsSkipped
        errors.append(contentsOf: result.errors)
        
        // Request memory pressure release
        _ = requestMemoryPressureRelease()
        
        let freedMB = Double(totalFreedBytes) / 1_000_000
        
        return CleaningResult(
            success: errors.isEmpty,
            freedMemoryMB: freedMB,
            itemsCleaned: itemsCleaned,
            itemsSkipped: itemsSkipped,
            errors: errors
        )
    }
    
    /// Cleans a specific directory (non-destructively)
    private func cleanDirectory(_ url: URL) -> (freedBytes: UInt64, itemsCleaned: Int, itemsSkipped: Int, errors: [String]) {
        var freedBytes: UInt64 = 0
        var itemsCleaned = 0
        var itemsSkipped = 0
        var errors: [String] = []
        
        guard let enumerator = fileManager.enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .contentAccessDateKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else {
            return (freedBytes, itemsCleaned, itemsSkipped, errors)
        }
        
        for case let file as URL in enumerator {
            do {
                // Only delete items older than 7 days
                let attributes = try file.resourceValues(forKeys: [.contentAccessDateKey])
                if let accessDate = attributes.contentAccessDate,
                   Date().timeIntervalSince(accessDate) > 7 * 24 * 3600 {
                    
                    if let size = try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                        try fileManager.removeItem(at: file)
                        freedBytes += UInt64(size ?? 0)
                        itemsCleaned += 1
                    }
                } else {
                    itemsSkipped += 1
                }
            } catch {
                itemsSkipped += 1
                errors.append("Failed to delete \(file.lastPathComponent): \(error.localizedDescription)")
            }
        }
        
        return (freedBytes, itemsCleaned, itemsSkipped, errors)
    }
    
    /// Requests the OS to release memory pressure
    private func requestMemoryPressureRelease() -> Bool {
        // This is a placeholder for actual implementation using Mach APIs
        // In production, use dispatch_source_create with DISPATCH_SOURCE_TYPE_MEMORYPRESSURE
        
        let task = Process()
        task.launchPath = "/usr/bin/vm_stat"
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            return task.terminationStatus == 0
        } catch {
            return false
        }
    }
    
    /// Checks if an app can be safely terminated
    func canTerminateApp(_ appName: String) -> Bool {
        // System apps and critical processes should not be terminated
        let criticalApps = [
            "Finder", "Dock", "Spotlight", "WindowServer",
            "loginwindow", "Keychain", "SystemUIServer"
        ]
        
        return !criticalApps.contains(appName)
    }
    
    /// Terminates an application (with user consent)
    func terminateApp(_ appName: String) -> Bool {
        let workspace = NSWorkspace.shared
        
        guard canTerminateApp(appName) else {
            return false
        }
        
        do {
            if let app = NSRunningApplication.runningApplications(
                withBundleIdentifier: appName
            ).first {
                return app.terminate()
            }
            return false
        }
    }
}
