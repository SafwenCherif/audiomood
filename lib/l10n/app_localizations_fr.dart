// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'AudioMood';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get goBack => 'Retour';

  @override
  String errorGeneric(String message) {
    return 'Erreur : $message';
  }

  @override
  String get language => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageFrench => 'Français';

  @override
  String get signIn => 'Connexion';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInSubtitle =>
      'Connectez-vous pour continuer votre voyage musical.';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get emailRequired => 'L\'e-mail est requis';

  @override
  String get emailInvalid => 'Entrez un e-mail valide';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get noAccountSignUp => 'Pas de compte ? Inscrivez-vous';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createAccountTitle => 'Créez votre compte';

  @override
  String get createAccountSubtitle =>
      'Inscrivez-vous pour enregistrer vos humeurs et playlists.';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get confirmPasswordRequired => 'Confirmez votre mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get onboardingTitle1 => 'Bienvenue sur AudioMood';

  @override
  String get onboardingSubtitle1 =>
      'Prenez un selfie et laissez l\'IA détecter votre humeur pour générer la playlist parfaite.';

  @override
  String get onboardingTitle2 => 'Une musique qui vous ressemble';

  @override
  String get onboardingSubtitle2 =>
      'Nous cherchons instantanément sur Deezer des titres adaptés à votre humeur actuelle.';

  @override
  String get onboardingTitle3 => 'Gardez votre vibe';

  @override
  String get onboardingSubtitle3 =>
      'Votre dernière humeur est enregistrée pour revenir sans attendre.';

  @override
  String get onboardingStart =>
      'Inscrivez-vous ou connectez-vous pour commencer';

  @override
  String get captureEmotion => 'Capturer l\'émotion';

  @override
  String get defaultUserName => 'Utilisateur AudioMood';

  @override
  String get showHistory => 'Voir l\'historique';

  @override
  String get signOut => 'Déconnexion';

  @override
  String get noFaceCaptured => 'Aucun visage capturé';

  @override
  String get detectionMethod => 'Méthode de détection';

  @override
  String get groqVision => 'Groq Vision';

  @override
  String get localTflite => 'TFLite local';

  @override
  String get mlKit => 'ML Kit';

  @override
  String lastMood(String emotion) {
    return 'Dernière humeur : $emotion';
  }

  @override
  String get useLastMood => 'Utiliser la dernière humeur';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get findPlaylist => 'Trouver une playlist';

  @override
  String get analyzing => 'Analyse...';

  @override
  String get signInToSaveHistory =>
      'Connectez-vous pour enregistrer votre historique d\'humeur.';

  @override
  String emotionDetected(String emotion) {
    return 'Émotion détectée : $emotion ! 🎵';
  }

  @override
  String playlistTitle(String emotion) {
    return 'Playlist $emotion 🎵';
  }

  @override
  String get fetchingFromDeezer => 'Recherche sur Deezer...';

  @override
  String get playlistLoadError =>
      'Oups ! Impossible de charger la musique.\nVérifiez votre connexion internet.';

  @override
  String get noTracksForMood => 'Aucun titre trouvé pour cette humeur.';

  @override
  String get noPreviewAvailable => 'Aucun aperçu audio pour ce titre.';

  @override
  String get moodHistory => 'Historique des humeurs';

  @override
  String get signInToViewHistory => 'Connectez-vous pour voir l\'historique.';

  @override
  String get historyOfflineMessage =>
      'L\'historique est stocké en ligne. Activez le Wi‑Fi ou les données mobiles pour charger vos humeurs passées.';

  @override
  String get connectionCheckFailed =>
      'Impossible de vérifier la connexion. Veuillez réessayer.';

  @override
  String get noHistoryYet => 'Aucun historique pour le moment.';

  @override
  String get deleteHistoryTitle => 'Supprimer cet historique ?';

  @override
  String get deleteHistoryMessage =>
      'Cela supprimera définitivement cet enregistrement d\'humeur.';

  @override
  String get historyDeleted => 'Historique supprimé.';

  @override
  String savedOn(String date) {
    return 'Enregistré le $date';
  }

  @override
  String get moodDetails => 'Détails de l\'humeur';

  @override
  String get noPreviewForMood => 'Aucun aperçu audio pour cette humeur.';

  @override
  String get pause => 'Pause';

  @override
  String get playPreview => 'Lire l\'aperçu';

  @override
  String get errorNoInternet =>
      'Pas de connexion internet. Activez le Wi‑Fi ou les données mobiles et réessayez.';

  @override
  String get errorTimeout =>
      'La requête a expiré. Le serveur met trop de temps à répondre. Veuillez réessayer.';

  @override
  String get errorCannotReachServer =>
      'Impossible de joindre le serveur. Vérifiez votre connexion internet et réessayez.';

  @override
  String get errorServer =>
      'Une erreur réseau s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get errorOperationTimeout =>
      'L\'opération a expiré. Vérifiez votre connexion et réessayez.';

  @override
  String get errorDatabaseUnavailable =>
      'Impossible d\'accéder à la base de données. Vérifiez votre connexion internet.';

  @override
  String get errorNoInternetShort =>
      'Pas de connexion internet. Vérifiez votre réseau et réessayez.';

  @override
  String get errorSomethingWrong =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get errorTitleOffline => 'Pas de connexion internet';

  @override
  String get errorTitleTimeout => 'Requête expirée';

  @override
  String get errorTitleServer => 'Erreur serveur';

  @override
  String get errorTitleUnknown => 'Une erreur s\'est produite';
}
