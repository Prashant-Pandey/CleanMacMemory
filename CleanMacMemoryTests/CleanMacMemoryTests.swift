import Foundation
import XCTest

@testable import CleanMacMemory

class MemoryAnalyzerTests: XCTestCase {
    var analyzer: MemoryAnalyzer!
    
    override func setUp() {
        super.setUp()
        analyzer = MemoryAnalyzer()
    }
    
    override func tearDown() {
        analyzer = nil
        super.tearDown()
    }
    
    func testAnalyzeSystemMemory() {
        let metrics = analyzer.analyzeSystemMemory()
        
        XCTAssertGreaterThanOrEqual(metrics.ramPercentage, 0)
        XCTAssertLessThanOrEqual(metrics.ramPercentage, 100)
        XCTAssertGreaterThan(metrics.ramUsageGB, 0)
        XCTAssertGreaterThanOrEqual(metrics.cachePercentage, 0)
        XCTAssertGreaterThanOrEqual(metrics.cacheSizeMB, 0)
    }
}

class MemoryCleanerTests: XCTestCase {
    var cleaner: MemoryCleaner!
    
    override func setUp() {
        super.setUp()
        cleaner = MemoryCleaner()
    }
    
    override func tearDown() {
        cleaner = nil
        super.tearDown()
    }
    
    func testCanTerminateAppRestriction() {
        // Critical apps should not be terminable
        XCTAssertFalse(cleaner.canTerminateApp("Finder"))
        XCTAssertFalse(cleaner.canTerminateApp("Dock"))
        XCTAssertFalse(cleaner.canTerminateApp("Spotlight"))
    }
}

class ActivityLoggerTests: XCTestCase {
    var logger: ActivityLogger!
    
    override func setUp() {
        super.setUp()
        logger = ActivityLogger()
    }
    
    override func tearDown() {
        logger = nil
        super.tearDown()
    }
    
    func testLogging() {
        logger.log("Test message 1")
        logger.log("Test message 2")
        
        let logs = logger.getRecentLogs()
        XCTAssertGreaterThanOrEqual(logs.count, 2)
    }
}
