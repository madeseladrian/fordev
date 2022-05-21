import '../../presentation/helpers/helpers.dart';
import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;
 
  const RequiredFieldValidation(this.field);
 
  @override
  ValidationError? validate(String? value) {
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }
}