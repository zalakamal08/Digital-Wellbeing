# MyDigitalWellbeing

A personal **digital wellbeing tracker** Android app built with Flutter.

## Features

- 📱 **App Usage Tracking** — Monitor which apps you use and for how long each day
- 📞 **Call Logs** — View incoming, outgoing, and missed calls with durations
- 💬 **SMS Tracking** — See SMS activity grouped by contact
- 📊 **Charts & Analytics** — Bar charts, pie charts, and hourly activity views
- 🔔 **Daily Summary Notification** — 9 PM daily recap pushed to your device
- ⚙️ **Background Sync** — WorkManager syncs data every 15 minutes (configurable)
- 🔐 **Privacy First** — All data stored locally using SQLite (Drift)

## Tech Stack

| Area | Package |
|------|---------|
| Database | `drift` + `drift_flutter` |
| Charts | `fl_chart` |
| Background Tasks | `workmanager` |
| Notifications | `flutter_local_notifications` |
| Permissions | `permission_handler` |
| Navigation | `go_router` |
| DI | `get_it` |
| Call Logs | `call_log` |
| SMS | `flutter_sms_inbox` |
| App Usage | `usage_stats` |

## Getting Started

### Prerequisites

- Flutter 3.22.0+ (`flutter --version`)
- Android SDK (API 21+)

### Setup

```bash
# Clone the repository
git clone https://github.com/zalakamal08/Digital-Wellbeing.git
cd Digital-Wellbeing

# Install dependencies
flutter pub get

# Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# Run on connected device/emulator
flutter run
```

### Building the APK

```bash
flutter build apk --release --no-tree-shake-icons
# Output: build/app/outputs/flutter-apk/app-release.apk
```

Or download from GitHub Actions — see [.github/workflows/README.md](.github/workflows/README.md)

## Required Permissions

| Permission | Purpose |
|------------|---------|
| `PACKAGE_USAGE_STATS` | App screen time tracking (requires manual enable in Settings > Usage Access) |
| `READ_CALL_LOG` | Call history |
| `READ_SMS` | SMS activity |
| `READ_CONTACTS` | Resolve contact names |
| `POST_NOTIFICATIONS` | Daily summary notification |
| `FOREGROUND_SERVICE` | Background data collection |
| `RECEIVE_BOOT_COMPLETED` | Restart sync after device reboot |

## Project Structure

```
lib/
├── main.dart              # Entry point + DI setup
├── app.dart               # Router + navigation shell
├── core/
│   ├── database/          # Drift DB, tables, DAOs
│   ├── services/          # Data sync services
│   └── permissions/       # Runtime permission management
├── features/
│   ├── onboarding/        # Permission onboarding flow
│   ├── dashboard/         # Home screen with daily overview
│   ├── app_usage/         # App usage list + charts
│   ├── calls/             # Call log list + stats
│   ├── sms/               # SMS grouped by contact
│   └── settings/          # Configuration & permissions
└── shared/
    ├── theme/             # Material3 dark theme
    └── widgets/           # Reusable components
```

## License

MIT
