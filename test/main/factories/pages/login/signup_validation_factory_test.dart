import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';
import 'package:fordev/main/factories/factories.dart';

void main() {
  test('1 - Should return the correct validations', () {
    final validations = makeSignUpValidations();

    expect(validations, const [
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', size: 3),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 3),
      RequiredFieldValidation('passwordConfirmation'),
      CompareFieldsValidation(field: 'passwordConfirmation', fieldToCompare: 'password')
    ]);
  });
}