import '../helpers.dart';

enum UIError {
  emailInUse,
  invalidCredentials,
  invalidField,
  requiredField,
  unexpected
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.emailInUse: return R.string.msgEmailInUse;
      case UIError.invalidCredentials: return R.string.msgInvalidCredentials;
      case UIError.invalidField: return R.string.msgInvalidField;
      case UIError.requiredField: return R.string.msgRequiredField;
      default: return R.string.msgUnexpectedError;
    }
  }
}