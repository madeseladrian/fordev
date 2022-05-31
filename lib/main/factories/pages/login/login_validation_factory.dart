import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';

import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').requiredField().email().build(),
    ...ValidationBuilder.field('password').requiredField().min(3).build(),
  ];
}