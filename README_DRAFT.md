# WapTrend — Flutter Social Platform

> A full-featured mobile social network — posts, profiles, follow graph, real-time audio/video calls, and in-app monetisation.

## Description

WapTrend is a Flutter mobile application that implements a social media platform with a feature set comparable to mainstream social apps. Users can create posts (text, images, video, polls), follow each other, engage with content, join clubs, and make audio/video calls via Agora RTC. The app includes Firebase authentication, FCM push notifications, GetX-based state management, and Realm for local persistence.

<!-- TODO: add screenshot at docs/screenshot.png -->
<!-- ![WapTrend Feed Screenshot](docs/screenshot.png) -->

## Live / Download

<!-- TODO: add Play Store link if published -->
<!-- 🛒 [Google Play Store](#) -->

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** GetX
- **Dependency Injection:** GetIt
- **Backend / Auth:** Firebase Auth, Firebase Messaging, Firebase Crashlytics
- **Real-time Calls:** Agora RTC Engine
- **Local DB:** Realm
- **Networking:** Dio (HTTP), with connectivity checks
- **Media:** Video Player, Just Audio, Audio Service, Image Picker
- **Ads:** Google Mobile Ads, In-App Purchases
- **Other:** Shimmer loading, local biometric auth, WebView

## Key Features

- 📱 **Social Feed** — paginated posts with images, video, polls, and tags
- 👤 **Profiles** — follow/follower graph, follow requests, blocked users, stats
- 📞 **Audio & Video Calls** — real-time calls via Agora RTC
- 🔔 **Push Notifications** — FCM-based, with local notifications
- 💰 **Monetisation** — in-app purchases, Google Mobile Ads integration
- 🔒 **Auth** — Firebase email/password + Apple Sign-In + OTP phone verification

## Project Structure

```
lib/
├── screens/        # UI screens (feed, profile, post, settings, calls, clubs)
├── controllers/    # GetX controllers per feature
├── models/         # Data models
└── util/           # Helpers, ad keys (loaded from server at runtime)
```

## Setup & Run

```bash
flutter pub get
# Add your own google-services.json and GoogleService-Info.plist (not committed)
# Set up Firebase project and Agora App ID via environment/CI
flutter run
```

> ⚠️ Firebase config files (`google-services.json`, `GoogleService-Info.plist`, `lib/firebase_options.dart`) are excluded from this repo for security. Generate them from your Firebase project using `flutterfire configure`.
