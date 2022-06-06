import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/params/params.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'package:fordev/ui/helpers/helpers.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email;
  late String password;
  late AccountEntity account;

  setUp(() {
    account = EntityFactory.makeAccount();
    email = faker.internet.email();
    password = faker.internet.password();
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    authentication.mockAuthentication(account);
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount
    );
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('1 - Should call Validation with correct email', () async {
    final formData = {'email': email, 'password': null};

    sut.validateEmail(email);
    
    verify(() => validation.validate(field: 'email', input: formData)).called(1);
  });

  test('2,3,4 - Should emailErrorStream returns invalidFieldError if email is empty', () async {
    validation.mockValidationError(value: ValidationError.invalidField);
   
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('2,3,4 - Should emailErrorStream returns requiredField if email is null', () async {
    validation.mockValidationError(value: ValidationError.requiredField);
   
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('5 - Should emailErrorStream returns null if validation email succeeds', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('6 - Should call Validation with correct password', () async {
    final formData = {'email': null, 'password': password};
    
    sut.validatePassword(password);
    
    verify(() => validation.validate(field: 'password', input: formData)).called(1);
  });

  test('7,8,9 - Should passwordErrorStream returns invalidFieldError if password is empty', () async {
    validation.mockValidationError(value: ValidationError.invalidField);
   
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('7,8,9 - Should passwordErrorStream returns requiredFieldError if password is null', () async {
    validation.mockValidationError(value: ValidationError.requiredField);
   
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('10 - Should passwordErrorStream returns null if validation password succeeds', () async {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('11 - Should isFormValidStream disable form button if any field is invalid', () async {
    validation.mockValidationError(field: 'email', value: ValidationError.requiredField);
    
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('12,13 - Should isFormValidStream enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('14 - Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    
    await sut.authenticate();

    verify(() => authentication.authenticate(
      AuthenticationParams(email: email, password: password)
    )).called(1);
  });

  test('15 - Should emit correct events on Authentication success', () async {
    expectLater(sut.isLoadingStream, emits(true));
    expectLater(sut.mainErrorStream, emits(null));

    await sut.authenticate();
  });

  test('16 - Should emit correct events on InvalidCredentialsError', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredentials);
    
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));

    await sut.authenticate();
  });

  test('17 - Should emit correct events on UnexpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.authenticate();
  });

  test('18 - Should call SaveCurrentAccount with correct values', () async {
    await sut.authenticate();

    verify(() => saveCurrentAccount.save(account)).called(1);
  });

  test('19 - Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    saveCurrentAccount.mockSaveError();
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.authenticate();
  });
  
  test('20 - Should change page on success authentication', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.authenticate();
  });

  test('21 - Should go to SignUpPage on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/signup')));

    sut.goToSignUp();
  });
} 