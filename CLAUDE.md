# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter** mobile application (baby_plan_v3) - **E.A.S.Y. 育儿助手**，帮助父母记录和分析宝宝的日常活动。

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

# Code generation (run after modifying models)
dart run build_runner build --delete-conflicting-outputs
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

- **State management**: Riverpod (`flutter_riverpod`) for reactive state management
- **Database**: Drift (SQLite ORM) for local data persistence
- **Immutable models**: Freezed for immutable data classes with code generation
- **JSON serialization**: json_serializable for JSON encoding/decoding
- **Testing**: Uses `flutter_test` package with `WidgetTester` for widget tests

### Dependencies

#### Core Dependencies
- `flutter` (SDK) - core framework
- `cupertino_icons` - iOS-style icons
- `flutter_riverpod` - state management
- `drift` + `drift_flutter` - SQLite ORM database
- `fl_chart` - charts and graphs
- `freezed_annotation` - immutable data class annotations
- `json_annotation` - JSON serialization annotations
- `flutter_skill` - MCP Server SDK for AI-driven automation

#### Development Dependencies
- `flutter_test` - testing framework
- `flutter_lints` - code analysis (see `analysis_options.yaml`)
- `build_runner` - code generation runner
- `drift_dev` - Drift code generator
- `freezed` - Freezed code generator
- `json_serializable` - JSON serialization generator

### Analysis

Code uses `flutter_lints` preset with additional rules (see `analysis_options.yaml`):
- `avoid_print: warning`
- `prefer_const_constructors: warning`
- `prefer_const_declarations: warning`
- `avoid_relative_lib_imports: error`
- `always_declare_return_types: warning`

Run `flutter analyze` to check for issues.

总是用中文回答！