import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/validation/validators/validators.dart';

import 'package:test/test.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(field: 'any_field', fieldToCompare: 'other_field');
  });

  test('1 - Should return error if values are not equal', () {
    final formData = {'any_field': 'any_value', 'other_field': 'other_value'};
    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('2 - Should return null if values are equal', () {
    final formData = {'any_field': 'any_value', 'other_field': 'any_value'};
    expect(sut.validate(formData), null);
  });

  test('3 - Should return null if one of the fields is missing', () {
    expect(sut.validate({'any_field': 'any_value'}), null);
    expect(sut.validate({'other_field': 'any_value'}), null);
  });

  test('4 - Should return null if one of the fields is missing and are null', () {
    expect(sut.validate({'any_field': null}), null);
    expect(sut.validate({'other_field': null}), null);
  });

  test('5 - Should return null if the values of the fields are null', () {
    expect(sut.validate({'any_field': null, 'other_field': null}), null);
  });

  test('6 - Should return null if both fields are missing', () {
    expect(sut.validate({}), null);
  });
}