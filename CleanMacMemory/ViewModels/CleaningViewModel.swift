import Foundation
import Combine

class CleaningViewModel: ObservableObject {
    @Published var ramUsagePercentage: Double = 0.0
    @Published var ramUsageGB: Double = 0.0
    @Published var cachePercentage: Double = 0.0
    @Published var cacheSizeMB: Double = 0.0
    @Published var isCleaningInProgress: Bool = false
    @Published var activityLog: [String] = []
    
    private let analyzer = MemoryAnalyzer()
    private let cleaner = MemoryCleaner()
    private let logger = ActivityLogger()
    
    func updateUsageMetrics() {
        let metrics = analyzer.analyzeSystemMemory()
        
        DispatchQueue.main.async {
            self.ramUsagePercentage = metrics.ramPercentage
            self.ramUsageGB = metrics.ramUsageGB
            self.cachePercentage = metrics.cachePercentage
            self.cacheSizeMB = metrics.cacheSizeMB
        }
    }
    
    func initiateCleaningProcess() {
        isCleaningInProgress = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Step 1: Analyze
            self.logger.log("Analyzing system memory and cache...")
            let analysis = self.analyzer.analyzeSystemMemory()
            
            // Step 2: Show summary (would trigger UI dialog in production)
            DispatchQueue.main.async {
                self.logger.log("Found \(Int(analysis.cacheSizeMB))MB cache to clean")
            }
            
            // Step 3: Execute cleaning
            self.logger.log("Starting cleanup process...")
            let result = self.cleaner.cleanSystemCache()
            
            // Step 4: Show results
            DispatchQueue.main.async {
                if result.success {
                    self.logger.log("✓ Cleaned \(Int(result.freedMemoryMB))MB of cache")
                    self.logger.log("✓ Optimization complete")
                } else {
                    self.logger.log("✗ Cleaning completed with some errors")
                }
                
                // Update metrics
                self.updateUsageMetrics()
                self.isCleaningInProgress = false
                self.activityLog = self.logger.getRecentLogs()
            }
        }
    }
}
