import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;
  
  setUp(() {
    sut = EmailValidation('any_field');
  });
 
  test('1 - Should return null if email is empty', () async {
    final error = sut.validate('');
    expect(error, null);
  });
}