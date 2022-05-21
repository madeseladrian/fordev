import '../../presentation/helpers/helpers.dart';

class EmailValidation  {
  final String field;
 
  EmailValidation(this.field);

  ValidationError? validate(String? value) {
    final regex = RegExp(
      r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value!);
    return isValid ? null : ValidationError.invalidField;
  }
}