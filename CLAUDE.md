# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter** mobile application (baby_plan_v3) - a starter project generated with `flutter create`. The app is a basic counter demo showcasing Flutter's standard patterns.

> **Note**: Windows desktop requires Visual Studio toolchain. Use `flutter run -d chrome` (Web) for development.

## Common Commands

```bash
# Run the app (Web - default)
flutter run -d chrome

# Run on a specific platform
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d macos
flutter run -d linux
flutter run -d chrome

# Run tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Analyze code for errors
flutter analyze

# Build for release
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build windows      # Windows
flutter build macos        # macOS
flutter build linux        # Linux

# Get dependencies
flutter pub get

# Format code
dart format .
```

## Code Architecture

### File Structure

```
lib/
  main.dart              # App entry point and root widget
test/
  widget_test.dart       # Basic widget test
```

### Key Patterns

- **Root widget**: `MyApp` extends `StatelessWidget` - configures MaterialApp with theme
- **Home page**: `MyHomePage` extends `StatefulWidget` - demonstrates basic counter state
- **State management**: Uses Flutter's built-in `setState` for local state
- **Testing**: Uses `flutter_test` package with `WidgetTester` for widget tests

### Dependencies

- `flutter` (SDK) - core framework
- `cupertino_icons` - iOS-style icons
- `flutter_test` - testing framework
- `flutter_lints` - code analysis (uses flutter.yaml preset)

### Analysis

Code uses `flutter_lints` preset (see `analysis_options.yaml`). Run `flutter analyze` to check for issues.

总是用中文回答！