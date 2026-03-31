# GitHub Actions — Build APK

This directory contains GitHub Actions workflows for the **MyDigitalWellbeing** Flutter project.

---

## Workflows

### `build_apk.yml` — Auto Build Release APK

**Triggers:**
- Every push to the `main` branch
- Manual trigger via the GitHub Actions UI (*workflow_dispatch*)

**Steps performed:**
1. Checkout the code
2. Set up Java 17 (Temurin)
3. Set up Flutter 3.22.0 (stable)
4. Run `flutter pub get`
5. Run Drift code generation (`dart run build_runner build`)
6. Build `app-release.apk` with `flutter build apk --release`
7. Upload the APK as a build artifact (retained for 30 days)

---

## How to Download the APK

1. Go to **[https://github.com/zalakamal08/Digital-Wellbeing/actions](https://github.com/zalakamal08/Digital-Wellbeing/actions)**
2. Click the most recent **"Build APK"** workflow run (green ✓ or orange ⏳)
3. Scroll down to the **"Artifacts"** section at the bottom of the run page
4. Click **`MyDigitalWellbeing-APK`** to download the ZIP
5. Extract the ZIP — inside you'll find `app-release.apk`
6. Transfer to your Android device and install (enable "Install from unknown sources" if prompted)

---

## How to Trigger a Manual Build

1. Go to **Actions** tab → **"Build APK"** workflow
2. Click **"Run workflow"** (top right)
3. Select the `main` branch
4. Click **"Run workflow"** green button
5. Wait ~5–10 minutes for the build to complete

---

## Notes

- The APK is a **debug-signed release APK** (signed with the debug keystore for simplicity)
- For production distribution, add a signing keystore and configure `signingConfigs` in `android/app/build.gradle`
- `minSdkVersion` is **21** (Android 5.0+)
- Drift code generation (`.g.dart` files) is run as part of the CI pipeline
