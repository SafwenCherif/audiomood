# AudioMood

**AudioMood** is a cross-platform Flutter application that detects facial emotions from a selfie, recommends music via the Deezer API, and saves each session to the cloud. The project was built as a final mini-project for mobile development (Flutter + Riverpod + AI).

## Features

- **Authentication** — Email/password and Google Sign-In (Firebase Auth)
- **Onboarding** — First-launch introduction (persisted with SharedPreferences)
- **Emotion detection** — Three methods:
  - **Groq Vision API** — Cloud LLM (`llama-3.2-90b-vision-preview`)
  - **TFLite** — On-device model (`model_unquant.tflite`)
  - **ML Kit** — Smile probability heuristics
- **Music playlist** — Deezer search API + 30s audio previews (`just_audio`)
- **Mood history** — Firestore (online) with photo URLs on Cloudinary
- **Local persistence** — Last emotion, onboarding flag, detection method preference
- **Network handling** — Connectivity checks, API timeouts (15s), user-friendly offline/timeout messages

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
| AI | TFLite, Google ML Kit, Groq Vision API |
| Connectivity | `connectivity_plus` |
| Local storage | `shared_preferences` |
| Secrets | `flutter_dotenv` (`.env`) |

## Project structure

```
lib/
├── main.dart                 # Entry point, Firebase init, ProviderScope
├── firebase_options.dart     # Generated Firebase config
├── core/
│   ├── network/              # Connectivity + error mapping
│   └── services/             # Firestore, Cloudinary
├── models/                   # Track, MoodHistoryModel
├── features/
│   ├── auth/                 # Login, register, onboarding, AuthWrapper
│   ├── emotion/              # Camera + AI detectors
│   ├── music/                # Playlist + audio providers
│   └── history/              # History list + detail
└── widgets/                  # TrackCard, HistoryCard, NetworkErrorView
```

## Prerequisites

- Flutter SDK `^3.11.0`
- A Firebase project (Auth + Firestore enabled)
- Cloudinary account (unsigned upload preset)
- Groq API key for cloud emotion detection ([console.groq.com](https://console.groq.com))

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

> The `.env` file is listed in `pubspec.yaml` assets. Do not commit secrets to public repositories.

### 4. Firestore rules

Mood history is stored under:

```
users/{userId}/mood_history/{historyId}
```

Ensure your security rules allow authenticated users to read/write their own subcollection.

### 5. Run the app

```bash
flutter run
```

## User flow

1. **Onboarding** (first launch) → **Login / Register**
2. **Camera screen** — Take a selfie, choose detection method, tap **Find Playlist**
3. Image uploaded to Cloudinary → emotion detected → Deezer playlist fetched → record saved to Firestore
4. **Playlist screen** — Browse tracks and play previews
5. **History** (drawer) — View, open, or delete past moods (requires internet)

## Persistence strategy

| Storage | Data | Purpose |
|---------|------|---------|
| **Firestore** | Mood history (image URL, emotion, preview URL, date) | Online, per-user, real-time stream |
| **SharedPreferences** | `last_emotion`, `onboarding_seen`, `emotion_method` | Offline shortcuts and settings |

## Network & error handling

- **`NetworkService`** (`lib/core/network/`) checks connectivity via `connectivity_plus`.
- API calls use **15-second timeouts** (Dio, Firestore writes).
- **Camera — Find Playlist**: blocks when offline; shows SnackBar for offline / timeout / server errors.
- **History screen**: shows `NetworkErrorView` when offline or when Firestore fails; **Try again** refreshes providers.

## APIs used

| API | Endpoint / usage |
|-----|------------------|
| Deezer | `GET https://api.deezer.com/search?q={emotion} music` |
| Cloudinary | `POST https://api.cloudinary.com/v1_1/{cloud}/image/upload` |
| Groq | `POST https://api.groq.com/openai/v1/chat/completions` |
| Firebase | Auth + Firestore SDK |

## Riverpod providers (summary)

| Provider | Type | Role |
|----------|------|------|
| `authStateProvider` | StreamProvider | Current Firebase user |
| `authControllerProvider` | StateNotifierProvider | Sign in, register, sign out |
| `playlistProvider` | FutureProvider.family | Deezer tracks per emotion |
| `moodHistoryStreamProvider` | StreamProvider.family | Live Firestore history |
| `networkServiceProvider` | Provider | Connectivity + error mapping |
| `hasInternetProvider` | FutureProvider | Online/offline check |

## Presentation demo tips

1. Show onboarding → login (email or Google).
2. Take a photo → explain the 3 AI methods.
3. Show playlist playback and history entry.
4. Turn off Wi‑Fi → demonstrate offline message on **Find Playlist** and **History**.
5. Mention dual persistence (Firestore + SharedPreferences) and Riverpod architecture.

## Known limitations

- Full “Find Playlist” flow requires internet (Cloudinary + Deezer + Firestore).
- TFLite / ML Kit can run offline for detection only, but saving history still needs network.
- Deezer previews are ~30 seconds and not available for every track.
- No mood statistics charts (optional enhancement).

## License

Academic / educational project.
