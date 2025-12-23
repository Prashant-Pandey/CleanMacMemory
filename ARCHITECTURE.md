# Architecture Overview

## Project Structure

```
CleanMacMemory/
├── CleanMacMemory/                 # Main app target
│   ├── CleanMacMemoryApp.swift     # App entry point
│   ├── Info.plist                  # App metadata
│   ├── CleanMacMemory.entitlements # Sandbox permissions
│   ├── Modules/                    # Core business logic
│   │   ├── Analyzer/
│   │   │   └── MemoryAnalyzer.swift
│   │   ├── Cleaner/
│   │   │   └── MemoryCleaner.swift
│   │   └── Logger/
│   │       └── ActivityLogger.swift
│   ├── Views/                      # SwiftUI views
│   │   └── ContentView.swift
│   └── ViewModels/                 # MVVM view models
│       └── CleaningViewModel.swift
├── CleanMacMemoryTests/            # Test suite
│   └── CleanMacMemoryTests.swift
├── CleanMacMemory.xcodeproj/       # Xcode project
├── .github/
│   ├── workflows/                  # CI/CD workflows
│   └── ISSUE_TEMPLATE/             # Issue templates
├── LICENSE                         # MIT License
├── README.md                        # Project overview
├── CONTRIBUTING.md                 # Contribution guidelines
├── SECURITY.md                      # Security policy
└── ARCHITECTURE.md                 # This file
```

## Design Pattern: MVVM

The application follows the Model-View-ViewModel (MVVM) architecture:

```
┌──────────────────────────────────────┐
│           SwiftUI Views              │
│      (ContentView, etc.)             │
└────────────────┬─────────────────────┘
                 │ observes
┌────────────────▼─────────────────────┐
│      ViewModel (Reactive)            │
│  (CleaningViewModel)                 │
│  - @Published properties             │
│  - State management                  │
└────────────────┬─────────────────────┘
                 │ uses
┌────────────────▼─────────────────────┐
│      Business Logic Modules          │
│  - MemoryAnalyzer (data analysis)    │
│  - MemoryCleaner (operations)        │
│  - ActivityLogger (persistence)      │
└──────────────────────────────────────┘
```

## Core Modules

### 1. Analyzer Module (`MemoryAnalyzer`)

**Responsibility**: Scan and analyze system memory and cache

**Key Types**:
- `MemoryMetrics` - Contains RAM and cache statistics
- `CleanableItem` - Represents a file/cache item that can be cleaned

**Key Methods**:
- `analyzeSystemMemory()` → `MemoryMetrics` - Get current usage
- `findCleanableItems()` → `[CleanableItem]` - Find deletable files

**Details**:
- Scans `/tmp`, `~/Library/Caches`, `~/Library/Application Support`
- Calculates sizes using `FileManager` APIs
- Uses `ProcessInfo` to get RAM metrics
- Non-destructive (read-only operations)

### 2. Cleaner Module (`MemoryCleaner`)

**Responsibility**: Execute cleaning operations safely

**Key Types**:
- `CleaningResult` - Contains cleanup summary and errors

**Key Methods**:
- `cleanSystemCache()` → `CleaningResult` - Execute cleaning
- `canTerminateApp(String)` → Bool - Check if app is safe to kill
- `terminateApp(String)` → Bool - Terminate an application

**Details**:
- Deletes only files older than 7 days (conservative approach)
- Maintains list of critical system apps (never terminates)
- Requests memory pressure release via system APIs
- Graceful error handling (skips inaccessible files)
- Returns detailed results including errors

### 3. Logger Module (`ActivityLogger`)

**Responsibility**: Record and provide activity history

**Key Methods**:
- `log(String)` - Add a timestamped log entry
- `getRecentLogs()` → `[String]` - Get last 50 logs
- `exportLogs(to:)` - Save logs to file

**Details**:
- Timestamped entries (HH:mm:ss format)
- Keeps rolling buffer of 50 most recent entries
- Thread-safe logging (dispatches to main queue)
- Supports export for user reference

## ViewModel Architecture

### CleaningViewModel

**Published Properties**:
- `@Published var ramUsagePercentage: Double`
- `@Published var ramUsageGB: Double`
- `@Published var cachePercentage: Double`
- `@Published var cacheSizeMB: Double`
- `@Published var isCleaningInProgress: Bool`
- `@Published var activityLog: [String]`

**Methods**:
- `updateUsageMetrics()` - Refresh system metrics
- `initiateCleaningProcess()` - Trigger async cleaning

**Flow**:
1. UI displays current metrics
2. User taps "Clean Now"
3. ViewModel starts background task
4. Analyzer runs, Cleaner executes, Logger records
5. Results posted back to main thread
6. UI updates with new metrics and logs

## Threading Model

- **Main Thread**: UI updates, property publishing
- **Background Thread**: All CPU-intensive work (analysis, file operations)
- **Synchronization**: DispatchQueue ensures thread-safe updates

```swift
DispatchQueue.global(qos: .userInitiated).async {
    // CPU-intensive work
    let result = cleaner.cleanSystemCache()
    
    DispatchQueue.main.async {
        // Update UI
        self.activityLog = self.logger.getRecentLogs()
    }
}
```

## Security Model

### Entitlements (Minimal)

The app requests minimal permissions:
- `com.apple.security.cs.allow-unsigned-executable-memory` = false
- No network access
- No camera/microphone access
- No USB access

### Privacy

- No data collection or telemetry
- No external communications
- No persistent personal data storage
- Logs are session-only

### Code Safety

- No force unwrapping (only safe `guard let`, optional binding)
- Graceful error handling for all file operations
- Conservative deletion (7+ day age requirement)
- Protected system app list

## Data Flow Diagram

```
┌─────────────────────┐
│   User Interaction  │
│   (UI Button Click) │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────┐
│    CleaningViewModel                │
│  - Coordinates operations           │
│  - Manages async tasks              │
└──────────┬──────────────────────────┘
           │
    ┌──────┼──────┐
    ▼      ▼      ▼
┌──────┐┌──────┐┌──────┐
│Analy-││Clean-││ Logr │
│zer  ││  er  ││      │
└──────┘└──────┘└──────┘
    │      │      │
    ├──────┴──────┤
    ▼             ▼
 System      Activity
  Files       Log
```

## Performance Targets

- **Memory**: App uses <50MB RAM
- **CPU**: <1% usage during operation
- **Cleanup Time**: <30 seconds for typical loads
- **Startup**: <5 seconds to launch

## Testing Strategy

### Unit Tests

```swift
class MemoryAnalyzerTests: XCTestCase
class MemoryCleanerTests: XCTestCase
class ActivityLoggerTests: XCTestCase
```

- Test core logic in isolation
- Mock file system operations
- Verify calculations and safety checks

### UI Tests (Future)

- Test button interactions
- Verify metric display updates
- Test confirmation dialogs

### Integration Tests

- End-to-end cleaning workflow
- File system integrity
- Memory release verification

## Future Architecture Enhancements

### Scheduled Cleaning

```
┌──────────────┐
│  Scheduler   │
│ (Background) │
└──────┬───────┘
       │
       ▼
┌──────────────────┐
│ CleaningViewModel│
└──────────────────┘
```

### Monitoring Dashboard

```
┌──────────────────────────┐
│   Monitoring Dashboard   │
│  - Real-time metrics     │
│  - Alerts                │
│  - History graphs        │
└──────────────────────────┘
```

### User Preferences

```
┌──────────────────────┐
│ PreferencesViewModel │
├──────────────────────┤
│ - Exclusion lists    │
│ - Cleanup schedule   │
│ - Notification opts  │
└──────────────────────┘
```

## Dependencies

- **Swift Standard Library** - Core functionality
- **Foundation** - File system, processes
- **SwiftUI** - User interface
- **Combine** - Reactive updates
- **AppKit** - macOS-specific APIs (NSWorkspace, NSRunningApplication)

**External Dependencies**: None (intentional for security and portability)

## Build Configuration

- **Target**: macOS 12.0+
- **Architecture**: ARM64 (Apple Silicon)
- **Swift Version**: 5.7+
- **Build Tool**: Xcode 14.0+

## Deployment

### Distribution Channels

1. **GitHub Releases** - DMG installer
2. **Source Code** - Direct clone from repository
3. **Future**: Homebrew, MacPorts

### Code Signing

- Signed with Apple Developer ID
- Notarized for Gatekeeper
- Verifiable authenticity

---

This architecture prioritizes simplicity, safety, and privacy while remaining extensible for future enhancements.
