import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/params/params.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import '../../mocks/mocks.dart';

void main() {
  late String url;
  late HttpClientSpy httpClient;
  late RemoteAuthentication sut;
  late Map apiResult;
  late AuthenticationParams params;

  setUp(() {
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password()
    );
    apiResult = {"accessToken": faker.guid.guid()};
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    httpClient.mockRequest(apiResult);
    sut = RemoteAuthentication(url: url, httpClient: httpClient);
  });
 
  test('1,2 - Should call HttpClient with correct values', () async {
    await sut.authenticate(params);
    verify(() => httpClient.request(
      url: url,
      method: 'post',
      body: {"email": params.email, "password": params.password}
    ));
  });

  test('3,4 - Should return an Account if HttpClient returns 200', () async {
    final account = await sut.authenticate(params);
    expect(account.token, apiResult['accessToken']);
  });

  test('5 - Should throw UnexpectedError if HttpClient returns 400', () async {
    httpClient.mockRequestError(HttpError.badRequest);
    final future = sut.authenticate(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('6 - Should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);
    final future = sut.authenticate(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('7 - Should throw UnexpectedError if HttpClient returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);
    final future = sut.authenticate(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('8 - Should throw InvalidCredentialsError if HttpClient returns 401', () async {
    httpClient.mockRequestError(HttpError.unauthorized);
    final future = sut.authenticate(params);
    expect(future, throwsA(DomainError.invalidCredentials));
  });
  
  test('9 - Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    httpClient.mockRequest({'invalid_key': 'invalid_value'});
    final future = sut.authenticate(params);
    expect(future, throwsA(DomainError.unexpected));
  });
}