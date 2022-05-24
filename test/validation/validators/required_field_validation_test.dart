import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;
  
  setUp(() {
    sut = const RequiredFieldValidation('any_field');
  });
 
  test('1 - Should return null if value is not empty', () async {
    final error = sut.validate({'any_field': 'any_value'});
    expect(error, null);
  });

  test('2 - Should return error if value is empty', () async {
    final error = sut.validate({'any_field': ''});
    expect(error, ValidationError.requiredField);
  });

  test('3 - Should return error if value is null', () async {
    final error = sut.validate({});
    expect(error, ValidationError.requiredField);
  });
}