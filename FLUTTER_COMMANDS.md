# Flutter Commands Reference

## Project Setup & Installation

### Check Flutter Installation
```bash
flutter --version
flutter doctor
flutter doctor -v
```

### Create New Project
```bash
flutter create project_name
flutter create --org com.example project_name
flutter create --platforms=android,ios,web project_name
```

### Upgrade Flutter
```bash
flutter upgrade
flutter channel stable
flutter channel beta
flutter downgrade
```

## Dependencies Management

### Install Dependencies
```bash
flutter pub get
flutter pub upgrade
flutter pub outdated
```

### Add Dependencies
```bash
flutter pub add package_name
flutter pub add package_name --dev
flutter pub remove package_name
```

### Clean Dependencies
```bash
flutter pub cache clean
flutter pub cache repair
```

## Development Commands

### Run Application
```bash
flutter run
flutter run -d chrome                    # Run on Chrome
flutter run -d android                   # Run on Android
flutter run -d ios                       # Run on iOS
flutter run --release                    # Run in release mode
flutter run --profile                    # Run in profile mode
flutter run --debug                      # Run in debug mode
flutter run -t lib/main_dev.dart        # Run specific entry point
```

### Hot Reload & Restart
```bash
# Press 'r' in terminal while app is running - Hot reload
# Press 'R' in terminal while app is running - Hot restart
# Press 'q' to quit
```

### List Devices
```bash
flutter devices
flutter emulators
flutter emulators --launch <emulator_id>
```

## Build Commands

### Android
```bash
flutter build apk                        # Build APK
flutter build apk --release              # Build release APK
flutter build apk --debug                # Build debug APK
flutter build apk --split-per-abi        # Build separate APKs per ABI
flutter build appbundle                  # Build App Bundle (AAB)
flutter build appbundle --release        # Build release App Bundle
```

### iOS
```bash
flutter build ios                        # Build iOS app
flutter build ios --release              # Build release iOS
flutter build iosarchive                 # Build iOS archive
flutter build ipa                        # Build IPA file
```

### Web
```bash
flutter build web                        # Build web app
flutter build web --release              # Build release web
flutter build web --web-renderer html    # Use HTML renderer
flutter build web --web-renderer canvaskit  # Use CanvasKit renderer
```

### Linux
```bash
flutter build linux
flutter build linux --release
```

### macOS
```bash
flutter build macos
flutter build macos --release
```

### Windows
```bash
flutter build windows
flutter build windows --release
```

## Testing

### Run Tests
```bash
flutter test                             # Run all tests
flutter test test/widget_test.dart       # Run specific test
flutter test --coverage                  # Generate coverage
flutter test --reporter expanded         # Verbose test output
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
flutter test integration_test
```

## Code Analysis & Formatting

### Analyze Code
```bash
flutter analyze
flutter analyze --watch
flutter analyze lib/
```

### Format Code
```bash
flutter format .
flutter format lib/
flutter format --set-exit-if-changed .
```

### Fix Code Issues
```bash
dart fix --dry-run                       # Preview fixes
dart fix --apply                         # Apply fixes
```

## Clean & Reset

### Clean Build Files
```bash
flutter clean
flutter clean && flutter pub get
```

### Reset Project
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

## Debugging & Profiling

### Debug Commands
```bash
flutter logs                             # View logs
flutter screenshot                       # Take screenshot
flutter symbolize --input=<stack-trace-file>
```

### Performance Profiling
```bash
flutter run --profile                    # Profile mode
flutter run --trace-startup             # Trace startup performance
flutter run --enable-vm-service         # Enable VM service
```

### DevTools
```bash
dart devtools
flutter pub global activate devtools
flutter pub global run devtools
```

## Configuration

### Configure Flutter
```bash
flutter config                           # Show all settings
flutter config --enable-web              # Enable web support
flutter config --enable-linux-desktop    # Enable Linux desktop
flutter config --enable-macos-desktop    # Enable macOS desktop
flutter config --enable-windows-desktop  # Enable Windows desktop
flutter config --android-sdk <path>      # Set Android SDK path
```

## Assets & Resources

### Generate Icons
```bash
flutter pub run flutter_launcher_icons:main
```

### Generate Splash Screen
```bash
flutter pub run flutter_native_splash:create
```

### Generate Localization
```bash
flutter gen-l10n
```

## Platform-Specific Commands

### Android
```bash
# Build and run on Android
adb devices                              # List connected devices
adb logcat                               # View Android logs
adb install build/app/outputs/flutter-apk/app-release.apk

# Gradle tasks
cd android && ./gradlew tasks
cd android && ./gradlew clean
```

### iOS
```bash
# Build and run on iOS
open ios/Runner.xcworkspace               # Open in Xcode
pod install                               # Install CocoaPods (from ios directory)
pod update                                # Update pods
```

## Continuous Integration

### Build for CI/CD
```bash
flutter build apk --release --no-tree-shake-icons
flutter build appbundle --release
flutter build ios --release --no-codesign
flutter test --coverage --machine > test-results.json
```

## Troubleshooting

### Common Fix Commands
```bash
# Fix build issues
flutter clean && flutter pub get && flutter run

# Fix Gradle issues
cd android && ./gradlew clean && cd ..

# Fix iOS issues
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..

# Fix permission issues (Linux/Mac)
flutter doctor --android-licenses

# Clear Flutter cache
flutter pub cache clean
flutter clean
rm -rf $HOME/.pub-cache
```

## Useful Shortcuts

### While App is Running
- `r` - Hot reload
- `R` - Hot restart
- `v` - Open DevTools
- `w` - Dump widget hierarchy
- `t` - Dump rendering tree
- `L` - Dump layer tree
- `p` - Toggle performance overlay
- `P` - Toggle grid overlay
- `i` - Toggle widget inspector
- `o` - Simulate different OS
- `s` - Take screenshot
- `q` - Quit

## Package Information

### Get Package Info
```bash
flutter pub deps                         # Show dependency tree
flutter pub deps --style=compact         # Compact dependency tree
flutter pub downgrade                    # Downgrade dependencies
```

## Generation Commands

### Code Generation
```bash
flutter pub run build_runner build       # Generate code once
flutter pub run build_runner watch       # Watch and generate
flutter pub run build_runner build --delete-conflicting-outputs
```

## Update App Version

### Version Management
```bash
# Update version in pubspec.yaml
# version: 1.0.0+1 (version+build number)

# Build with version
flutter build apk --release --build-name=1.0.0 --build-number=1
```

## Quick Setup Script

```bash
#!/bin/bash
# Quick setup script for Flutter project
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks
flutter pub get
cd ios && pod install && cd ..
flutter run
```

---

**Note:** Save this file for quick reference during development!
