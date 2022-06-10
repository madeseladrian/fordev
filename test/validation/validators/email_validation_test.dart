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

// Use: for testing against email regex
// ref: http://codefool.tumblr.com/post/15288874550/list-of-valid-and-invalid-email-addresses


// List of Valid Email Addresses

// email@example.com
// firstname.lastname@example.com
// email@subdomain.example.com
// firstname+lastname@example.com
// email@123.123.123.123
// email@[123.123.123.123]
// "email"@example.com
// 1234567890@example.com
// email@example-one.com
// _______@example.com
// email@example.name
// email@example.museum
// email@example.co.jp
// firstname-lastname@example.com



// List of Strange Valid Email Addresses

// much.”more\ unusual”@example.com
// very.unusual.”@”.unusual.com@example.com
// very.”(),:;<>[]”.VERY.”very@\\ "very”.unusual@strange.example.com



// List of Invalid Email Addresses

// plainaddress
// #@%^%#$@#$@#.com
// @example.com
// Joe Smith <email@example.com>
// email.example.com
// email@example@example.com
// .email@example.com
// email.@example.com
// email..email@example.com
// あいうえお@example.com
// email@example.com (Joe Smith)
// email@example
// email@-example.com
// email@example.web
// email@111.222.333.44444
// email@example..com
// Abc..123@example.com



// List of Strange Invalid Email Addresses

// ”(),:;<>[\]@example.com
// just”not”right@example.com
// this\ is"really"not\allowed@example.com