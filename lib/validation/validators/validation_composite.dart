import '../../presentation/helpers/helpers.dart';
import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation{
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError? validate({required String field, required String value}) {
    return null;
  } 
}