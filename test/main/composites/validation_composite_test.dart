import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/main/composites/composites.dart';
import '../../validation/mocks/mocks.dart';

void main() {
  late ValidationComposite sut;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;

  setUp(() {
    validation1 = FieldValidationSpy();
    validation1.mockFieldName('other_field');
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();
    sut = ValidationComposite([validation1, validation2, validation3]);
  });
 
  test('1 - Should return null if all validations returns null', () async {
    final formData = {'any_field': 'any_value'};
    
    final error = sut.validate(field: 'any_field', input: formData);

    expect(error, null);
  });

  test('2 - Should return the first error', () async {
    validation1.mockValidationError(ValidationError.invalidField);
    validation2.mockValidationError(ValidationError.requiredField);
    validation3.mockValidationError(ValidationError.invalidField);

    final formData = {'any_field': 'any_value'};
    final error = sut.validate(field: 'any_field', input: formData);

    expect(error, ValidationError.requiredField);
  });
}