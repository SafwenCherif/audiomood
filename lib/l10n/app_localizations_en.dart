// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AudioMood';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get refresh => 'Refresh';

  @override
  String get tryAgain => 'Try again';

  @override
  String get goBack => 'Go back';

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'French';

  @override
  String get signIn => 'Sign in';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to continue your music journey.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get noAccountSignUp => 'Don\'t have an account? Sign up';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountTitle => 'Create your account';

  @override
  String get createAccountSubtitle =>
      'Sign up to save your moods and playlists.';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordRequired => 'Confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get onboardingTitle1 => 'Welcome to AudioMood';

  @override
  String get onboardingSubtitle1 =>
      'Capture a selfie and let AI detect your vibe to generate the perfect playlist.';

  @override
  String get onboardingTitle2 => 'Music that matches you';

  @override
  String get onboardingSubtitle2 =>
      'We search Deezer instantly to find tracks that fit your current mood.';

  @override
  String get onboardingTitle3 => 'Save your vibe';

  @override
  String get onboardingSubtitle3 =>
      'Your last mood is saved so you can jump back in without waiting.';

  @override
  String get onboardingStart => 'Sign up or sign in to start';

  @override
  String get captureEmotion => 'Capture Emotion';

  @override
  String get defaultUserName => 'AudioMood User';

  @override
  String get showHistory => 'Show history';

  @override
  String get signOut => 'Sign out';

  @override
  String get noFaceCaptured => 'No face captured yet';

  @override
  String get detectionMethod => 'Detection method';

  @override
  String get groqVision => 'Groq Vision';

  @override
  String get localTflite => 'Local TFLite';

  @override
  String get mlKit => 'ML Kit';

  @override
  String lastMood(String emotion) {
    return 'Last mood: $emotion';
  }

  @override
  String get useLastMood => 'Use last mood';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get findPlaylist => 'Find Playlist';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get signInToSaveHistory => 'Please sign in to save your mood history.';

  @override
  String emotionDetected(String emotion) {
    return 'Emotion detected: $emotion! 🎵';
  }

  @override
  String playlistTitle(String emotion) {
    return '$emotion Playlist 🎵';
  }

  @override
  String get fetchingFromDeezer => 'Fetching vibes from Deezer...';

  @override
  String get playlistLoadError =>
      'Oops! Couldn\'t load music.\nCheck your internet connection.';

  @override
  String get noTracksForMood => 'No tracks found for this mood.';

  @override
  String get noPreviewAvailable => 'No audio preview available for this track.';

  @override
  String get moodHistory => 'Mood History';

  @override
  String get signInToViewHistory => 'Please sign in to view history.';

  @override
  String get historyOfflineMessage =>
      'Mood history is stored online. Turn on Wi‑Fi or mobile data to load your past moods.';

  @override
  String get connectionCheckFailed =>
      'Could not check your connection. Please try again.';

  @override
  String get noHistoryYet => 'No history yet.';

  @override
  String get deleteHistoryTitle => 'Delete history?';

  @override
  String get deleteHistoryMessage =>
      'This will permanently remove this mood record.';

  @override
  String get historyDeleted => 'History deleted.';

  @override
  String savedOn(String date) {
    return 'Saved on $date';
  }

  @override
  String get moodDetails => 'Mood Details';

  @override
  String get noPreviewForMood => 'No preview audio available for this mood.';

  @override
  String get pause => 'Pause';

  @override
  String get playPreview => 'Play preview';

  @override
  String get errorNoInternet =>
      'No internet connection. Please turn on Wi‑Fi or mobile data and try again.';

  @override
  String get errorTimeout =>
      'The request timed out. The server took too long to respond. Please try again.';

  @override
  String get errorCannotReachServer =>
      'Unable to reach the server. Check your internet connection and try again.';

  @override
  String get errorServer =>
      'A network error occurred while contacting the server. Please try again later.';

  @override
  String get errorOperationTimeout =>
      'The operation timed out. Please check your connection and try again.';

  @override
  String get errorDatabaseUnavailable =>
      'Cannot reach the database. Check your internet connection and try again.';

  @override
  String get errorNoInternetShort =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorSomethingWrong => 'Something went wrong. Please try again.';

  @override
  String get errorTitleOffline => 'No internet connection';

  @override
  String get errorTitleTimeout => 'Request timed out';

  @override
  String get errorTitleServer => 'Server error';

  @override
  String get errorTitleUnknown => 'Something went wrong';
}
