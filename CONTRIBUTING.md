# Contributing to CleanMacMemory

Thank you for your interest in contributing to CleanMacMemory! We welcome contributions from everyone, regardless of experience level.

## Code of Conduct

This project is committed to providing a welcoming and inspiring community for all. Please read and follow our Code of Conduct.

## How to Contribute

### Reporting Bugs

Before creating a bug report, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps which reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed after following the steps**
- **Explain which behavior you expected to see instead and why**
- **Include macOS version and Mac model information**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- **Use a clear and descriptive title**
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the steps**
- **Describe the current behavior and expected behavior**

### Pull Requests

- Fill in the required template
- Follow the Swift styleguide
- Include appropriate test cases
- Update documentation as needed
- End all files with a newline

## Development Setup

### Prerequisites

- macOS 12.0+
- Xcode 14.0+
- Swift 5.7+

### Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/CleanMacMemory.git`
3. Create a feature branch: `git checkout -b feature/your-feature`
4. Make your changes
5. Run tests: `xcodebuild test -scheme CleanMacMemory`
6. Commit with a clear message: `git commit -m 'Add feature description'`
7. Push to your fork: `git push origin feature/your-feature`
8. Create a Pull Request

## Styleguide

### Swift Style Guide

- Use 4 spaces for indentation
- Follow Apple's Swift API Design Guidelines
- Keep lines under 120 characters where possible
- Use meaningful variable names
- Add comments for complex logic
- Use `// MARK:` for code organization

### Code Organization

```swift
// MARK: - Properties

// MARK: - Lifecycle

// MARK: - Public Methods

// MARK: - Private Methods
```

## Testing

- Write unit tests for all new functionality
- Maintain or increase test coverage
- Test on both Intel and Apple Silicon Macs if possible
- Include UI tests for view changes

## Documentation

- Update README.md for significant changes
- Add inline comments for complex logic
- Document public APIs with Swift DocC comments
- Update CHANGELOG if applicable

## Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions

## Questions?

Feel free to open an issue or discussion for any questions about contributing.

Thank you for helping make CleanMacMemory better! 🎉
