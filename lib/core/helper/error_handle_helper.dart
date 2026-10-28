import 'package:shoply_app/l10n/app_localizations.dart';

class ErrorHandleHelper {
  static String getCustomErrorMessage(AppLocalizations l10n, String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
      case 'wrong-password':
        return l10n.authErrorInvalidCredential;
      case 'email-already-in-use':
        return l10n.authErrorEmailInUse;
      case 'weak-password':
        return l10n.authErrorWeakPassword;
      case 'invalid-email':
        return l10n.authErrorInvalidEmail;
      case 'user-disabled':
        return l10n.authErrorUserDisabled;
      case 'user-not-found':
        return l10n.authErrorUserNotFound;
      case 'too-many-requests':
        return l10n.authErrorTooManyRequests;
      case 'network-request-failed':
        return l10n.authErrorNetwork;
      case 'image-upload-failed':
        return l10n.authErrorImageUpload;
      default:
        return l10n.authErrorUnexpected;
    }
  }
}
