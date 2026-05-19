import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AudioMood'**
  String get appTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorGeneric(String message);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your music journey.'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @noAccountSignUp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noAccountSignUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to save your moods and playlists.'**
  String get createAccountSubtitle;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AudioMood'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Capture a selfie and let AI detect your vibe to generate the perfect playlist.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Music that matches you'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'We search Deezer instantly to find tracks that fit your current mood.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Save your vibe'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Your last mood is saved so you can jump back in without waiting.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Sign up or sign in to start'**
  String get onboardingStart;

  /// No description provided for @captureEmotion.
  ///
  /// In en, this message translates to:
  /// **'Capture Emotion'**
  String get captureEmotion;

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'AudioMood User'**
  String get defaultUserName;

  /// No description provided for @showHistory.
  ///
  /// In en, this message translates to:
  /// **'Show history'**
  String get showHistory;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @noFaceCaptured.
  ///
  /// In en, this message translates to:
  /// **'No face captured yet'**
  String get noFaceCaptured;

  /// No description provided for @detectionMethod.
  ///
  /// In en, this message translates to:
  /// **'Detection method'**
  String get detectionMethod;

  /// No description provided for @groqVision.
  ///
  /// In en, this message translates to:
  /// **'Groq Vision'**
  String get groqVision;

  /// No description provided for @localTflite.
  ///
  /// In en, this message translates to:
  /// **'Local TFLite'**
  String get localTflite;

  /// No description provided for @mlKit.
  ///
  /// In en, this message translates to:
  /// **'ML Kit'**
  String get mlKit;

  /// No description provided for @lastMood.
  ///
  /// In en, this message translates to:
  /// **'Last mood: {emotion}'**
  String lastMood(String emotion);

  /// No description provided for @useLastMood.
  ///
  /// In en, this message translates to:
  /// **'Use last mood'**
  String get useLastMood;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @findPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Find Playlist'**
  String get findPlaylist;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @signInToSaveHistory.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to save your mood history.'**
  String get signInToSaveHistory;

  /// No description provided for @emotionDetected.
  ///
  /// In en, this message translates to:
  /// **'Emotion detected: {emotion}! 🎵'**
  String emotionDetected(String emotion);

  /// No description provided for @playlistTitle.
  ///
  /// In en, this message translates to:
  /// **'{emotion} Playlist 🎵'**
  String playlistTitle(String emotion);

  /// No description provided for @fetchingFromDeezer.
  ///
  /// In en, this message translates to:
  /// **'Fetching vibes from Deezer...'**
  String get fetchingFromDeezer;

  /// No description provided for @playlistLoadError.
  ///
  /// In en, this message translates to:
  /// **'Oops! Couldn\'t load music.\nCheck your internet connection.'**
  String get playlistLoadError;

  /// No description provided for @noTracksForMood.
  ///
  /// In en, this message translates to:
  /// **'No tracks found for this mood.'**
  String get noTracksForMood;

  /// No description provided for @noPreviewAvailable.
  ///
  /// In en, this message translates to:
  /// **'No audio preview available for this track.'**
  String get noPreviewAvailable;

  /// No description provided for @moodHistory.
  ///
  /// In en, this message translates to:
  /// **'Mood History'**
  String get moodHistory;

  /// No description provided for @signInToViewHistory.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view history.'**
  String get signInToViewHistory;

  /// No description provided for @historyOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Mood history is stored online. Turn on Wi‑Fi or mobile data to load your past moods.'**
  String get historyOfflineMessage;

  /// No description provided for @connectionCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not check your connection. Please try again.'**
  String get connectionCheckFailed;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet.'**
  String get noHistoryYet;

  /// No description provided for @deleteHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete history?'**
  String get deleteHistoryTitle;

  /// No description provided for @deleteHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove this mood record.'**
  String get deleteHistoryMessage;

  /// No description provided for @historyDeleted.
  ///
  /// In en, this message translates to:
  /// **'History deleted.'**
  String get historyDeleted;

  /// No description provided for @savedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date}'**
  String savedOn(String date);

  /// No description provided for @moodDetails.
  ///
  /// In en, this message translates to:
  /// **'Mood Details'**
  String get moodDetails;

  /// No description provided for @noPreviewForMood.
  ///
  /// In en, this message translates to:
  /// **'No preview audio available for this mood.'**
  String get noPreviewForMood;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @playPreview.
  ///
  /// In en, this message translates to:
  /// **'Play preview'**
  String get playPreview;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please turn on Wi‑Fi or mobile data and try again.'**
  String get errorNoInternet;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. The server took too long to respond. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorCannotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the server. Check your internet connection and try again.'**
  String get errorCannotReachServer;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred while contacting the server. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorOperationTimeout.
  ///
  /// In en, this message translates to:
  /// **'The operation timed out. Please check your connection and try again.'**
  String get errorOperationTimeout;

  /// No description provided for @errorDatabaseUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the database. Check your internet connection and try again.'**
  String get errorDatabaseUnavailable;

  /// No description provided for @errorNoInternetShort.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errorNoInternetShort;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorSomethingWrong;

  /// No description provided for @errorTitleOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorTitleOffline;

  /// No description provided for @errorTitleTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get errorTitleTimeout;

  /// No description provided for @errorTitleServer.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get errorTitleServer;

  /// No description provided for @errorTitleUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitleUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
