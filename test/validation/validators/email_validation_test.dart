import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;
  
  setUp(() {
    sut = const EmailValidation('any_field');
  });
 
  test('1 - Should return null if email is empty', () async {
    final error = sut.validate({'any_field': ''});
    expect(error, null);
  });

  test('2 - Should return null if email is null', () async {
    final error = sut.validate({});
    expect(error, null);
  });
 
  test('3 - Should return null if email is valid', () async {
    final error = sut.validate({'any_field': 'mades@gmail.com'});
    expect(error, null);
  });
  
  test('4 - Should return error if email is invalid', () async {
    expect(sut.validate({'any_field': 'madesgmail.com'}), ValidationError.invalidField);

    //expect(sut.validate({'any_field': 'Mades@gmail.com'}), ValidationError.invalidField);
  });
}