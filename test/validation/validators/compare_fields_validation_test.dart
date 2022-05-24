import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(field: 'any_field', valueToCompare: 'any_value');
  });

  test('1 - Should return error if values are not equal', () {
    final error = sut.validate('wrong_value');
    expect(error, ValidationError.invalidField);
  });

  test('2 - Should return error if values are not equal', () {
    final error = sut.validate('any_value');
    expect(error, null);
  });
}