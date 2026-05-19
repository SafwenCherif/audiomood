# AudioMood

**AudioMood** is a cross-platform Flutter application that detects facial emotions from a selfie, recommends music via the Deezer API, and saves each session to the cloud. Built as a mobile development mini-project using **Flutter**, **Riverpod**, **Firebase**, and **AI** (on-device ML + cloud LLM).

## Features

- **Authentication** — Email/password and Google Sign-In (Firebase Auth)
- **Onboarding** — First-launch introduction (persisted with `SharedPreferences`)
- **Emotion detection** — Three selectable methods:
  - **Groq Vision** — Cloud LLM (`meta-llama/llama-4-scout-17b-16e-instruct`) with JSON-structured responses
  - **TFLite** — On-device model (`model_unquant.tflite`) with face cropping via ML Kit
  - **ML Kit** — Smile-probability heuristics (HAPPY / SAD / NEUTRAL)
- **Music playlist** — Deezer search API + 30-second audio previews (`just_audio`)
- **Mood history** — Firestore (online, real-time stream) with photos hosted on Cloudinary
- **Local persistence** — Last emotion, onboarding flag, preferred detection method
- **Network layer** — Centralized connectivity checks, 15s API timeouts, user-friendly error messages
- **Reusable widgets** — `TrackCard`, `HistoryCard`, `NetworkErrorView`

## Tech stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Material 3) |
| State management | Riverpod (`flutter_riverpod`) |
| Auth | Firebase Auth + Google Sign-In |
| Database | Cloud Firestore |
| Image hosting | Cloudinary |
| Music API | Deezer REST API |
| HTTP client | Dio |
| AI | Groq Vision API, TFLite, Google ML Kit |
| Connectivity | `connectivity_plus` |
| Local storage | `shared_preferences` |
| Secrets | `flutter_dotenv` (`.env`) |
| Audio | `just_audio` |

## Architecture

The project uses a **feature-based layered architecture**:

```text
Screens (UI)  →  Riverpod Providers  →  Core Services  →  External APIs
```

| Layer | Location | Responsibility |
|-------|----------|----------------|
| **Presentation** | `lib/features/`, `lib/widgets/` | Screens, forms, reusable widgets |
| **State** | `*_provider.dart` files | Riverpod providers, caching, reactivity |
| **Core** | `lib/core/` | Network handling, Firestore, Cloudinary |
| **Models** | `lib/models/` | Data classes (`Track`, `MoodHistoryModel`) |
| **External** | APIs + Firebase + on-device ML | Groq, Deezer, Cloudinary, Firestore, TFLite |

## Project structure

```
lib/
├── main.dart                          # Entry point, Firebase init, ProviderScope
├── firebase_options.dart              # Generated Firebase config
│
├── core/
│   ├── network/
│   │   ├── network_service.dart       # Connectivity, timeouts, error mapping
│   │   └── network_provider.dart      # networkServiceProvider, hasInternetProvider
│   └── services/
│       ├── firestore_service.dart     # Mood history CRUD + live stream
│       └── cloudinary_service.dart    # Image upload (Dio + timeouts)
│
├── models/
│   ├── track_model.dart               # Deezer track (fromJson)
│   └── mood_history_model.dart        # Firestore document
│
├── features/
│   ├── auth/
│   │   ├── auth_provider.dart         # Firebase auth + AuthController
│   │   ├── auth_wrapper.dart          # Root gate (onboarding / login / home)
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── onboarding_screen.dart
│   ├── emotion/
│   │   ├── emotion_provider.dart      # Camera state providers
│   │   ├── camera_screen.dart         # Main hub (camera + analysis UI)
│   │   ├── groq_emotion_detector.dart # Cloud vision LLM (Groq)
│   │   ├── tflite_emotion_detector.dart
│   │   └── ml_kit_emotion_detection.dart
│   ├── music/
│   │   ├── music_provider.dart        # Playlist, audio player providers
│   │   └── playlist_screen.dart
│   └── history/
│       ├── history_provider.dart      # Firestore + Cloudinary providers
│       ├── history_screen.dart        # List with offline/error handling
│       └── history_detail_screen.dart
│
└── widgets/
    ├── track_card.dart                # Deezer track row (cover, play/pause)
    ├── history_card.dart              # Mood history list item
    └── network_error_view.dart        # Full-screen offline/timeout/error UI
```

## Prerequisites

- Flutter SDK `^3.11.0`
- A Firebase project (Authentication + Firestore enabled)
- Cloudinary account with an **unsigned upload preset**
- Groq API key ([console.groq.com](https://console.groq.com))

## Setup

### 1. Clone and install dependencies

```bash
git clone <your-repo-url>
cd audiomood
flutter pub get
```

### 2. Firebase

- Add `google-services.json` (Android) and configure iOS if needed.
- Run `flutterfire configure` if `firebase_options.dart` is missing.

### 3. Environment variables

Create a `.env` file at the project root:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_UPLOAD_PRESET=your_unsigned_preset
GROQ_API_KEY=your_groq_api_key
```

> The `.env` file is listed in `pubspec.yaml` assets. **Do not commit secrets** to public repositories.

### 4. Firestore structure & rules

Mood history is stored under:

```
users/{userId}/mood_history/{historyId}
```

Document fields: `userId`, `imageUrl`, `mood`, `previewUrl`, `createdAt`.

Ensure security rules allow authenticated users to read/write **only their own** subcollection.

### 5. Run the app

```bash
flutter run
```

## User flow

1. **Onboarding** (first launch only) → **Login / Register** (email or Google)
2. **Camera screen** — Take a selfie, select detection method (Groq / TFLite / ML Kit)
3. Tap **Find Playlist**:
   - Connectivity check
   - Upload image → Cloudinary
   - Detect emotion → Groq / TFLite / ML Kit
   - Fetch tracks → Deezer API
   - Save session → Firestore
4. **Playlist screen** — Browse tracks, play 30s previews
5. **History** (drawer) — View, open, or swipe-to-delete past moods
6. **Use last mood** — Replay last playlist without taking a new photo (local cache)

## Emotion detection methods

| Method | File | Runs on | Internet required | Labels |
|--------|------|---------|-------------------|--------|
| **Groq Vision** | `groq_emotion_detector.dart` | Cloud | Yes | HAPPY, SAD, ANGRY, NEUTRAL, CALM, CRAZY, FRUSTRATED |
| **TFLite** | `tflite_emotion_detector.dart` | Device | No* | Happy, Sad, Neutral, Angry, Thinking (from `labels.txt`) |
| **ML Kit** | `ml_kit_emotion_detection.dart` | Device | No* | HAPPY, SAD, NEUTRAL (smile probability) |

\*Detection can run offline, but the full **Find Playlist** flow still requires internet (Cloudinary + Deezer + Firestore).

### Groq Vision details

- **Endpoint:** `POST https://api.groq.com/openai/v1/chat/completions`
- **Model:** `meta-llama/llama-4-scout-17b-16e-instruct`
- **Input:** Base64 image via `image_url` content block
- **Output:** JSON `{"label":"HAPPY"}` with `response_format: json_object`
- **API key:** Loaded from `.env` → `GROQ_API_KEY`

## Persistence strategy

| Storage | Keys / data | Purpose |
|---------|-------------|---------|
| **Firestore** | Mood history documents | Online, per-user, real-time `StreamProvider` |
| **SharedPreferences** | `last_emotion` | Quick “Use last mood” shortcut |
| | `onboarding_seen` | Skip intro on next launch |
| | `emotion_method` | Remember Groq / TFLite / ML Kit choice |
| **`.env`** | API keys | Secrets kept out of source code |

## Network & error handling

### `NetworkService` (`lib/core/network/network_service.dart`)

Central service responsible for:

| Method | Purpose |
|--------|---------|
| `hasInternetConnection()` | Checks `connectivity_plus` (Wi‑Fi / mobile / none) |
| `ensureConnected()` | Throws `NetworkException` if offline |
| `NetworkService.from(error)` | Maps Dio, `TimeoutException`, Firestore errors → user-friendly messages |

**Failure types:** `offline` · `timeout` · `server` · `unknown`

**Default timeout:** 15 seconds (`NetworkService.defaultTimeout`)

Applied to: Cloudinary upload, Groq API, Deezer API, Firestore writes, and the camera “Find Playlist” pipeline.

### Where errors are shown

| Screen | Trigger | UI |
|--------|---------|-----|
| **Camera** — Find Playlist | Offline, timeout, API failure | Red **SnackBar** with clear message |
| **History** | Offline before load | **`NetworkErrorView`** (wifi icon + Try again) |
| **History** | Firestore / network failure | **`NetworkErrorView`** with mapped error type |
| **History** — delete | Offline during swipe delete | Red **SnackBar** |

### `NetworkErrorView` (`lib/widgets/network_error_view.dart`)

Reusable full-screen widget showing:

- Icon based on failure type (wifi off, timer, cloud, generic)
- Title (e.g. “No internet connection”, “Request timed out”)
- Detailed message
- Optional **Try again** button (invalidates `hasInternetProvider` + `moodHistoryStreamProvider`)

## Reusable widgets

| Widget | File | Used in |
|--------|------|---------|
| `TrackCard` | `track_card.dart` | `PlaylistScreen` — album art, title, artist, play/pause |
| `HistoryCard` | `history_card.dart` | `HistoryScreen` — thumbnail, mood, date |
| `NetworkErrorView` | `network_error_view.dart` | `HistoryScreen` — offline / timeout / server errors |

## APIs used

| API | Method | Endpoint / usage |
|-----|--------|------------------|
| **Groq** | POST | `https://api.groq.com/openai/v1/chat/completions` |
| **Cloudinary** | POST | `https://api.cloudinary.com/v1_1/{cloud}/image/upload` |
| **Deezer** | GET | `https://api.deezer.com/search?q={emotion} music` |
| **Firebase Auth** | SDK | Sign in, register, Google OAuth, sign out |
| **Firestore** | SDK | `users/{userId}/mood_history` stream + CRUD |

## Riverpod providers

| Provider | Type | Role |
|----------|------|------|
| `firebaseAuthProvider` | Provider | Firebase Auth instance |
| `googleSignInProvider` | Provider | Google Sign-In client |
| `authStateProvider` | StreamProvider | Live Firebase user (`User?`) |
| `authControllerProvider` | StateNotifierProvider | Sign in, register, Google, sign out |
| `onboardingSeenProvider` | FutureProvider | First-launch flag from SharedPreferences |
| `networkServiceProvider` | Provider | `NetworkService` singleton |
| `hasInternetProvider` | FutureProvider | Device connectivity check |
| `firestoreServiceProvider` | Provider | Firestore CRUD wrapper |
| `cloudinaryServiceProvider` | Provider | Cloudinary upload wrapper |
| `moodHistoryStreamProvider` | StreamProvider.family | Live mood list per `userId` |
| `playlistProvider` | FutureProvider.family | Deezer tracks per `emotion` |
| `audioPlayerProvider` | Provider | Shared `AudioPlayer` (auto-dispose) |
| `currentlyPlayingProvider` | StateProvider | Preview URL of playing track |
| `lastEmotionProvider` | FutureProvider | Last mood from SharedPreferences |
| `emotionMethodProvider` | StateProvider | groq / tflite / mlkit selection (`emotion_provider.dart`) |
| `selectedImagePathProvider` | StateProvider | Captured photo file path |
| `isLoadingProvider` | StateProvider | Find Playlist loading state |

## Navigation

Imperative navigation with `Navigator.push` / `Navigator.pop` (no `go_router`).

```text
AuthWrapper
├── OnboardingScreen   (first launch)
├── LoginScreen        → RegisterScreen
└── CameraScreen       (logged in — home)
    ├── PlaylistScreen
    └── HistoryScreen → HistoryDetailScreen
```

`AuthWrapper` reactively switches screens when `authStateProvider` emits a user — no manual navigation after login.

## Presentation demo tips

1. Show **onboarding** → **login** (email or Google SSO).
2. Take a photo → explain the **3 AI methods** (cloud LLM vs on-device).
3. Play a **Deezer preview** and open **history** to show the saved entry.
4. Turn off **Wi‑Fi** → tap **Find Playlist** (SnackBar) and open **History** (`NetworkErrorView`).
5. Turn Wi‑Fi back on → **Try again** / refresh.
6. Mention **Riverpod architecture**, **dual persistence**, and the **centralized network layer**.

## Known limitations

- Full **Find Playlist** flow requires internet (Cloudinary + Deezer + Firestore).
- TFLite / ML Kit detect emotions offline, but saving history still needs network.
- `connectivity_plus` detects connection type, not guaranteed reachability of every API.
- Deezer previews are ~30 seconds and not available for every track.
- `HistoryDetailScreen` uses its own `AudioPlayer`, separate from the playlist player.
- No mood statistics / charts (optional future enhancement).

## License

Academic / educational project.
