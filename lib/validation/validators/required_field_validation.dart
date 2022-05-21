import '../../presentation/helpers/helpers.dart';

class RequiredFieldValidation {
  final String field;
 
  const RequiredFieldValidation(this.field);
 
  ValidationError? validate(String? value) {
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }
}