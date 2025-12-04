# MSHPrescribe Mobile App

> **⚠️ UNOFFICIAL PROJECT** - This app is independently developed and not affiliated with Metro South Health or Queensland Health.

A native Flutter mobile application for [mshprescribe.com](https://mshprescribe.com), providing Queensland Health clinicians with offline access to evidence-based clinical guidelines, calculators, and prescribing information.

## Features

- **Hybrid Architecture**: Native UI with WebView content for always up-to-date guidelines
- **Queensland Health SSO**: Seamless authentication via Microsoft 365
- **Smart URL Resolution**: Self-healing links with search fallback
- **Native Bookmarks**: Save pages for offline access
- **In-App Search**: Fast guideline search with native UI
- **Site Crawler**: Developer tool to automatically discover and map all guideline URLs
- **Offline Caching**: WebView-based caching for visited pages

## Quick Start

### Prerequisites

- **Flutter SDK**: Version 3.38.3 or later ([Installation Guide](https://docs.flutter.dev/get-started/install))
- **Android Studio**: For Android development ([Download](https://developer.android.com/studio))
  - Android SDK Command-line Tools
  - Android Emulator or physical device
- **Xcode**: For iOS development (macOS only)

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd mshprescribe-app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── bookmark.dart         # Bookmark data model
│   └── menu_item.dart        # Menu item model
├── screens/
│   ├── home_screen.dart      # Main navigation screen
│   ├── webview_screen.dart   # WebView wrapper with SSO
│   ├── guidelines_list_screen.dart
│   ├── surgery_list_screen.dart
│   ├── bookmarks_screen.dart
│   ├── crawler_screen.dart   # Site crawler tool
│   └── web_search_delegate.dart
├── services/
│   └── storage_service.dart  # SQLite database service
└── utils/
    └── constants.dart        # App constants and configuration
```

## Architecture

### Hybrid Approach
- **Native Flutter UI**: Navigation, search, bookmarks
- **WebView Content**: Live website content via `flutter_inappwebview`
- **Benefits**: Up-to-date content, minimal maintenance

### URL Strategy
1. **Database-First**: Check `StorageService` for saved URLs
2. **Search Fallback**: If no URL found, search for category name (`/#search/[query]`)
3. **Manual Linking**: Users can link pages to categories via WebView menu
4. **Site Crawler**: Developer tool to auto-discover all URLs

### Authentication
- SSO handled entirely within WebView
- Cookies persisted via `sharedCookiesEnabled: true`
- Logout clears all cookies

### Data Storage
- **SQLite** (via `sqflite`): Bookmarks and category URL mappings
- **Shared Preferences**: App settings (if needed)
- **WebView Cache**: Automatic caching for offline access

## Development Guide

### Running on Different Platforms

**Android Emulator**:
```bash
flutter run
```

**iOS Simulator** (macOS only):
```bash
flutter run -d "iPhone 15 Pro"
```

**Web** (for testing UI only, WebView won't work):
```bash
flutter run -d chrome
```

### Using the Site Crawler

1. Launch the app and log in
2. Tap the menu (⋮) on the home screen
3. Select "Developer: Crawl Site"
4. Wait for the scan to complete
5. All category URLs will be saved to the database

### Adding New Categories

1. Update `AppConstants.guidelineCategories` in `constants.dart`
2. Run the Site Crawler to discover URLs automatically
3. Or manually link pages using the WebView menu option

### Debugging

**Enable verbose logging**:
```bash
flutter run -v
```

**View logs**:
```bash
flutter logs
```

**Analyze code**:
```bash
flutter analyze
```

## Dependencies

- `flutter_inappwebview`: ^6.1.5 - WebView with advanced features
- `url_launcher`: ^6.3.1 - Launch external URLs
- `shared_preferences`: ^2.3.3 - Simple key-value storage
- `sqflite`: ^2.4.1 - SQLite database
- `path`: ^1.9.0 - File path utilities
- `provider`: ^6.1.2 - State management

## Known Issues

- **First Build**: Takes 5-15 minutes due to NDK download
- **Windows NDK**: May require manual deletion if corrupted
- **Search URLs**: Don't link search result pages (validation in place)

## Troubleshooting

### Android Build Issues

**NDK Error**:
```bash
Remove-Item -Path "C:\Users\<USER>\AppData\Local\Android\sdk\ndk\*" -Recurse -Force
flutter clean
flutter run
```

**License Issues**:
```bash
flutter doctor --android-licenses
```

### WebView Not Loading

- Ensure device/emulator has internet connection
- Check that SSO cookies are enabled in `webview_screen.dart`
- Clear app data and re-login

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright © 2025 Ashane Herath

## Disclaimer

**This is an UNOFFICIAL mobile application** developed independently by Ashane Herath. It is not affiliated with, endorsed by, or officially associated with Metro South Health, Queensland Health, or mshprescribe.com.

This app is provided as a personal project for educational and convenience purposes. Users should always verify clinical information with official sources.

## Support

For issues or questions about this app, please open an issue on [GitHub](https://github.com/AshaneH/mshprescribe-app/issues).

For official MSHPrescribe website support, visit [mshprescribe.com/contact](https://mshprescribe.com/contact).
