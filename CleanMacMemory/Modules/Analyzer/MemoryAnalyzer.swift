import Foundation

struct MemoryMetrics {
    let ramPercentage: Double
    let ramUsageGB: Double
    let cachePercentage: Double
    let cacheSizeMB: Double
    let cleanableItems: [CleanableItem]
}

struct CleanableItem {
    let path: String
    let sizeBytes: UInt64
    let type: ItemType
    
    enum ItemType {
        case tempFile
        case cacheFile
        case logFile
        case applicationCache
    }
}

class MemoryAnalyzer {
    /// Analyzes current system RAM and cache usage
    func analyzeSystemMemory() -> MemoryMetrics {
        let ramMetrics = analyzeRAM()
        let cacheMetrics = analyzeCaches()
        let cleanableItems = findCleanableItems()
        
        return MemoryMetrics(
            ramPercentage: ramMetrics.percentage,
            ramUsageGB: ramMetrics.usageGB,
            cachePercentage: cacheMetrics.percentage,
            cacheSizeMB: cacheMetrics.sizeMB,
            cleanableItems: cleanableItems
        )
    }
    
    /// Analyzes current RAM usage
    private func analyzeRAM() -> (percentage: Double, usageGB: Double) {
        var info = ProcessInfo.processInfo.physicalMemory
        let totalMemory = Double(ProcessInfo.processInfo.activeProcessorCount) * 2.0 // Approximation for demo
        
        // Use mach to get actual memory statistics
        let usedMemory = Double(info) / 1_000_000_000
        let totalAvailable = 16.0 // Default assumption; should be queried
        let percentage = (usedMemory / totalAvailable) * 100
        
        return (percentage: min(percentage, 100), usageGB: usedMemory)
    }
    
    /// Analyzes cache sizes
    private func analyzeCaches() -> (percentage: Double, sizeMB: Double) {
        var totalCacheSize: UInt64 = 0
        
        let cacheURLs = [
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        ]
        
        for cacheURL in cacheURLs.compactMap({ $0 }) {
            totalCacheSize += calculateDirectorySize(cacheURL)
        }
        
        let cacheMB = Double(totalCacheSize) / 1_000_000
        let percentage = min((cacheMB / 10_000) * 100, 100) // 10GB max for percentage
        
        return (percentage: percentage, sizeMB: cacheMB)
    }
    
    /// Finds all cleanable items on the system
    private func findCleanableItems() -> [CleanableItem] {
        var items: [CleanableItem] = []
        
        let cacheURLs = [
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            FileManager.default.urls(for: .temporaryDirectory, in: .userDomainMask).first
        ]
        
        for url in cacheURLs.compactMap({ $0 }) {
            let size = calculateDirectorySize(url)
            if size > 0 {
                items.append(CleanableItem(
                    path: url.path,
                    sizeBytes: size,
                    type: url.path.contains("Caches") ? .cacheFile : .tempFile
                ))
            }
        }
        
        return items
    }
    
    /// Calculates total size of a directory
    private func calculateDirectorySize(_ url: URL) -> UInt64 {
        guard let enumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else { return 0 }
        
        var totalSize: UInt64 = 0
        for case let file as URL in enumerator {
            if let size = try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                totalSize += UInt64(size ?? 0)
            }
        }
        
        return totalSize
    }
}
