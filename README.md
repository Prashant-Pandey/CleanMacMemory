# CleanMacMemory

A lightweight, open-source RAM and cache cleaner for macOS on Apple Silicon (ARM64).

## Features

✨ **One-Click Cleaning** - Clean RAM and cache with a single button
📊 **Real-Time Metrics** - Monitor RAM and cache usage in real-time
🔒 **Privacy-First** - Zero data collection, no telemetry
⚡ **Lightweight** - Minimal resource footprint (<50MB RAM)
🎯 **ARM64 Optimized** - Built natively for Apple Silicon Macs

## Requirements

- **macOS 12.0+** on Apple Silicon (M1, M2, M3, etc.)
- **Xcode 14.0+** for development
- **Swift 5.7+**

## Architecture

### Modular Design

The app is organized into focused modules:

- **Analyzer** (`MemoryAnalyzer`) - Scans system for cleanable items
- **Cleaner** (`MemoryCleaner`) - Executes cleaning operations
- **Logger** (`ActivityLogger`) - Records actions for transparency
- **Views** - SwiftUI UI components
- **ViewModels** - MVVM architecture with reactive updates

## Building

### From Xcode

1. Open `CleanMacMemory.xcodeproj`
2. Select the `CleanMacMemory` scheme
3. Build: ⌘B
4. Run: ⌘R

### From Command Line

```bash
xcodebuild -scheme CleanMacMemory -configuration Release build
```

## Testing

Run the test suite in Xcode:

```bash
⌘U  # Run all tests
```

Or from the command line:

```bash
xcodebuild test -scheme CleanMacMemory
```

## Security

- **Code Signing**: Built with Apple Developer ID
- **Entitlements**: Minimal requested permissions
- **No External Dependencies**: Swift standard library only
- **Open Source**: Full transparency via MIT License

## Privacy

This application:
- Collects no user data
- Sends no telemetry
- Makes no external network connections
- Stores no persistent logs
- Is fully auditable as open-source code

## Development

### Project Structure

```
CleanMacMemory/
├── CleanMacMemory/
│   ├── CleanMacMemoryApp.swift
│   ├── Modules/
│   │   ├── Analyzer/
│   │   ├── Cleaner/
│   │   └── Logger/
│   ├── Views/
│   ├── ViewModels/
│   ├── Info.plist
│   └── CleanMacMemory.entitlements
├── CleanMacMemoryTests/
└── README.md
```

### Key Classes

- `MemoryAnalyzer` - Analyzes RAM and cache usage
- `MemoryCleaner` - Performs cleanup operations
- `ActivityLogger` - Maintains activity history
- `CleaningViewModel` - MVVM view model
- `ContentView` - Main UI view

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Roadmap

- [x] Project structure and core modules
- [ ] Complete UI implementation
- [ ] Memory pressure API integration
- [ ] Scheduled cleaning
- [ ] Monitoring dashboard
- [ ] User exclusion lists
- [ ] Preferences window
- [ ] Installer and app signing

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or suggestions, please open an [issue](https://github.com/Prashant-Pandey/CleanMacMemory/issues) on GitHub.

---

Built with ❤️ for Mac users who value privacy and simplicity.