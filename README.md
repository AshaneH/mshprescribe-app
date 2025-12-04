# MSHPrescribe Mobile App

> **⚠️ UNOFFICIAL PROJECT** - This app is independently developed and not affiliated with Metro South Health or Queensland Health.

An unofficial native mobile app for accessing [mshprescribe.com](https://mshprescribe.com) clinical guidelines on your phone.

## What is this?

MSHPrescribe is a web-based clinical decision support tool used by Queensland Health clinicians. This mobile app provides:

- **Native mobile interface** for easier navigation on phones
- **Offline bookmarks** to save important guidelines
- **Fast search** across all clinical content
- **Persistent login** via Queensland Health SSO

## Features

### 📱 Native Mobile Experience
- Clean bottom navigation for Guidelines, Surgery, Updates, and Bookmarks
- Optimized for one-handed use on mobile devices

### 🔖 Bookmark Management
- Save frequently accessed guidelines for offline reference
- Quick access from dedicated Bookmarks tab
- SQLite-based local storage

### 🔍 Smart Search
- Native search interface
- Automatically redirects to relevant content
- Search history preservation

### 🔐 Seamless Authentication
- Login once with your QH credentials
- Session persists across app restarts
- Secure cookie-based authentication

### 🌐 Offline Support
- Automatic caching of visited pages
- Bookmarked pages available offline
- WebView-based content storage

## Download & Install

### Android
1. Download the APK from [Releases](../../releases)
2. Enable "Install from Unknown Sources" in Settings
3. Install the APK
4. Launch and log in with QH credentials

### iOS
_iOS version pending Apple Developer Program enrollment_

## Requirements

- **Android**: Version 5.0 (Lollipop) or higher
- **iOS**: Version 12.0 or higher (when available)
- **Network**: Internet connection required for initial login and content updates
- **Account**: Valid Queensland Health credentials

## Usage

### First Launch
1. Open the app
2. Log in with your QH (Novell) account
3. Navigate through Guidelines or Drug Use in Surgery sections
4. Tap any category to view content

### Bookmarking
1. Open any guideline page
2. Tap the **bookmark icon** (top-right)
3. Access saved bookmarks from the Bookmarks tab

### Searching
1. Tap the **search icon** (top-right on home screen)
2. Type your query
3. Press Enter to search

### Logout / Clear Cache
1. Tap the **menu** (⋮) on home screen
2. Select "Logout / Clear Cache"
3. Re-login with credentials

## Known Limitations

- Requires internet connection for first-time content access
- Some external links open in system browser
- Search results show as web pages (not fully native)

## Troubleshooting

**App won't load content:**
- Check your internet connection
- Log out and log back in
- Clear app data from Android Settings

**Pages load slowly:**
- First load downloads content
- Subsequent loads use cache
- Bookmarked pages load faster

**Login issues:**
- Ensure using correct QH credentials
- Check if VPN is required for off-site access
- Contact QH IT support for account issues

## Privacy & Security

- No clinical data is stored by this app
- Login credentials handled by QH SSO (Microsoft 365)
- Bookmarks stored locally on device
- App does not transmit data to third parties

## Disclaimer

**This is an UNOFFICIAL mobile application** developed independently by Ashane Herath. It is not affiliated with, endorsed by, or officially associated with Metro South Health, Queensland Health, or mshprescribe.com.

This app provides a mobile interface to access existing web content. All clinical information comes directly from the official mshprescribe.com website. Users should verify critical clinical decisions with official sources and current guidelines.

**Use at your own risk.** The developer makes no warranties regarding accuracy, reliability, or suitability for clinical use.

## Development

Want to build or modify this app? See [DEVELOPMENT.md](DEVELOPMENT.md) for technical documentation.

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright © 2025 Ashane Herath

## Support

**For app issues:**
- Open an issue on [GitHub](https://github.com/AshaneH/mshprescribe-app/issues)

**For official MSHPrescribe website support:**
- Visit [mshprescribe.com/contact](https://mshprescribe.com/contact)

## Acknowledgments

- MSHPrescribe website content © Metro South Health
- App icon uses Flutter default (customization pending)
- Built with [Flutter](https://flutter.dev)
