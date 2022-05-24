import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', valueToCompare: 'other_field');
  });

  test('Should return error if value is not equal', () {
    final error = sut.validate('wrong_value');
    expect(error, ValidationError.invalidField);
  });
}