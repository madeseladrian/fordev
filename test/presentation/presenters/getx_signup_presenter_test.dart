import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/ui/helpers/errors/ui_error.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;
  late ValidationSpy validation;
  late GetxSignUpPresenter sut;
 
  
  When mockValidationCall(String? field) => when(() => validation.validate(
    field: field ?? any(named: 'field'),
    value: any(named: 'value'),
  ));
  void mockValidation({String? field}) => mockValidationCall(field).thenReturn(null);
  void mockValidationError({String? field, required ValidationError value}) => 
    mockValidationCall(field).thenReturn(value);
    
  setUp(() {
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    validation = ValidationSpy();
    mockValidation();
    sut = GetxSignUpPresenter(
      validation: validation
    );
  });

  test('1 - Should call Validation with correct name', () async {
    sut.validateName(name);
    
    verify(() => validation.validate(field: 'name', value: name)).called(1);
  });

  
  test('2,3,4 - Should nameErrorStream returns invalidFieldError if name is empty', () async {
    mockValidationError(value: ValidationError.invalidField);
   
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('2,3,4 - Should nameErrorStream returns requiredFieldError if name is null', () async {
    mockValidationError(value: ValidationError.requiredField);
   
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('5 - Should nameErrorStream returns null if validation name succeeds', () async {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validateName(name);
    sut.validateName(name);
  });

  test('6 - Should call Validation with correct email', () async {
    sut.validateEmail(email);
    
    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('7,8,9 - Should emailErrorStream returns invalidFieldError if email is empty', () async {
    mockValidationError(value: ValidationError.invalidField);
   
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
  test('7,8,9 - Should emailErrorStream returns requiredFieldError if email is null', () async {
    mockValidationError(value: ValidationError.requiredField);
   
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('10 - Should emailErrorStream returns null if validation email succeeds', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('11 - Should call Validation with correct password', () async {
    sut.validatePassword(password);
    
    verify(() => validation.validate(field: 'password', value: password)).called(1);
  });

  test('12,13,14 - Should passwordErrorStream returns invalidFieldError if password is empty', () async {
    mockValidationError(value: ValidationError.invalidField);
   
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('12,13,14 - Should passwordErrorStream returns requiredFieldError if password is null', () async {
    mockValidationError(value: ValidationError.requiredField);
   
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('15 - Should emailErrorStream returns null if validation email succeeds', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('16 - Should call Validation with correct passwordConfirmation', () async {
    sut.validatePasswordConfirmation(passwordConfirmation);
    
    verify(() => validation.validate(
      field: 'passwordConfirmation', 
      value: passwordConfirmation 
    )).called(1);
  });

  test('17,18,19 - Should passwordConfirmationErrorStream returns invalidFieldError if password is empty', () async {
    mockValidationError(value: ValidationError.invalidField);
   
    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('17,18,19 - Should passwordConfirmationErrorStream returns requiredFieldError if password is null', () async {
    mockValidationError(value: ValidationError.requiredField);
   
    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });
} 