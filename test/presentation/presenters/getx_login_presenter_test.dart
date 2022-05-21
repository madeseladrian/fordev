import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/ui/helpers/helpers.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late String email;
  late String password;
  late ValidationSpy validation;
  late GetxLoginPresenter sut;
 
  When mockValidationCall(String? field) => when(() => validation.validate(
    field: field ?? any(named: 'field'),
    value: any(named: 'value'),
  ));
  void mockValidation({String? field}) => mockValidationCall(field).thenReturn(null);
  void mockValidationError({String? field, required ValidationError value}) => 
    mockValidationCall(field).thenReturn(value);
    
  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();
    validation = ValidationSpy();
    mockValidation();
    
    sut = GetxLoginPresenter(
      validation: validation 
    );
  });

  test('1 - Should call Validation with correct email', () async {
    sut.validateEmail(email);
    
    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('2,3,4 - Should requiredFieldError if email is empty', () async {
    mockValidationError(value: ValidationError.invalidField);
   
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('5 - Should returns null if validation email succeeds', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('6 - Should call Validation with correct password', () async {
    sut.validatePassword(password);
    
    verify(() => validation.validate(field: 'password', value: password)).called(1);
  });

  test('7,8,9 - Should requiredFieldError if password is null', () async {
    mockValidationError(value: ValidationError.requiredField);
   
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    
    sut.validatePassword(password);
    sut.validatePassword(password);
  });
} 