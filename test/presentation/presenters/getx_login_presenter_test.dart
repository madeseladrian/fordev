import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/params/params.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/ui/helpers/helpers.dart';

class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  late String email;
  late String password;
  late AccountEntity accountEntity;
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late GetxLoginPresenter sut;
 
  When mockValidationCall(String? field) => when(() => validation.validate(
    field: field ?? any(named: 'field'),
    value: any(named: 'value'),
  ));
  void mockValidation({String? field}) => mockValidationCall(field).thenReturn(null);
  void mockValidationError({String? field, required ValidationError value}) => 
    mockValidationCall(field).thenReturn(value);
    
  When mockAuthenticationCall() => when(() => authentication.authenticate(any()));
  void mockAuthentication(AccountEntity data) => 
    mockAuthenticationCall().thenAnswer((_) async => data);
  void mockAuthenticationError(DomainError error) => mockAuthenticationCall().thenThrow(error);
  
  AccountEntity makeAccount() => AccountEntity(token: faker.guid.guid());

  AuthenticationParams makeAuthentication() => AuthenticationParams(
    email: faker.internet.email(),
    password: faker.internet.password()
  );

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();
    accountEntity = makeAccount();
    validation = ValidationSpy();
    mockValidation();
    authentication = AuthenticationSpy();
    mockAuthentication(accountEntity);
    sut = GetxLoginPresenter(
      authentication: authentication,
      validation: validation 
    );
  });

  setUpAll(() {
    registerFallbackValue(makeAccount());
    registerFallbackValue(makeAuthentication());
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

  test('7,8,9,10 - Should returns requiredFieldError if password is null', () async {
    mockValidationError(value: ValidationError.requiredField);
   
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('11 - Should disable form button if any field is invalid', () async {
    mockValidationError(field: 'email', value: ValidationError.requiredField);
    
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('11 - Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('12 - Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    
    await sut.authenticate();

    verify(() => authentication.authenticate(
      AuthenticationParams(email: email, password: password)
    )).called(1);
  });

  test('13 - Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    
    expectLater(sut.isLoadingStream, emits(true));

    await sut.authenticate();
  });

  test('14 - Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);
    
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => 
      expect(error, UIError.invalidCredentials)));

    await sut.authenticate();
  });
} 