import 'package:test/test.dart';

import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  test('1 - Should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, const [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ]);
  });
}