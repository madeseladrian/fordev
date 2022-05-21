import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';

abstract class FieldValidation {
  String get field;
  ValidationError? validate(String value);
}

class RequiredFieldValidation {
  final String field;
 
  const RequiredFieldValidation(this.field);
 
  ValidationError? validate(String? value) {
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }
}

void main() {
  late RequiredFieldValidation sut;
  
  setUp(() {
    sut = const RequiredFieldValidation('any_field');
  });
 
  test('1 - Should return null if value is not empty', () async {
    final error = sut.validate('any_value');
    expect(error, null);
  });

  test('2 - Should return error if value is empty', () async {
    final error = sut.validate('');
    expect(error, ValidationError.requiredField);
  });
}