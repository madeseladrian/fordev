import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/validation/protocols/field_validation.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({ required this.field, required this.size});

  @override
  ValidationError? validate(String? value) {
    return value != null && value.length >= size 
      ? null : ValidationError.invalidField;
  }
}

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 3);
  });

  test('1 - Should return error if value is empty', () {
    final error = sut.validate('');
    expect(error, ValidationError.invalidField);
  });

  test('2 - Should return error if value is null', () {
    final error = sut.validate(null);
    expect(error, ValidationError.invalidField);
  });

  test('3 - Should return error if value is less than min size', () {
    final error = sut.validate(faker.randomGenerator.string(3, min: 1));
    expect(error, ValidationError.invalidField);
  });

  test('4 - Should return null if value is equal min size', () {
    final name = sut.validate(faker.randomGenerator.string(3, min: 3));
    expect(name, null);
  });

  test('5 - Should return null if value is bigger than min size', () {
    final name = sut.validate(faker.randomGenerator.string(10, min: 6));
    expect(name, null);
  });
}