import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/params/params.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late String url;
  late HttpClientSpy httpClient;
  late RemoteAddAccount sut;
  late Map apiResult;
  late AddAccountParams params;

  When mockRequestCall() => when(() => httpClient.request(
    url: any(named: 'url'),
    method: any(named: 'method'),
    body: any(named: 'body')
  ));
  void mockRequest(dynamic data) => 
    mockRequestCall().thenAnswer((_) async => data);
  void mockError(HttpError error) => mockRequestCall().thenThrow(error);

  setUp(() {
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password()
    );
    apiResult = {"accessToken": faker.guid.guid()};
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    mockRequest(apiResult);
    sut = RemoteAddAccount(url: url, httpClient: httpClient);
  });
 
  test('1,2 - Should call HttpClient with correct values', () async {
    await sut.add(params);
    verify(() => httpClient.request(
      url: url,
      method: 'post',
      body: {
        "name": params.name,
        "email": params.email, 
        "password": params.password,
        "passwordConfirmation": params.passwordConfirmation                            
      }
    ));
  });

  test('3,4 - Should return an Account if HttpClient returns 200', () async {
    final account = await sut.add(params);
    expect(account.token, apiResult['accessToken']);
  });

  test('5 - Should throw UnexpectedError if HttpClient returns 400', () async {
    mockError(HttpError.badRequest);
    final future = sut.add(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('6 - Should throw UnexpectedError if HttpClient returns 404', () async {
    mockError(HttpError.notFound);
    final future = sut.add(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('7 - Should throw UnexpectedError if HttpClient returns 500', () async {
    mockError(HttpError.serverError);
    final future = sut.add(params);
    expect(future, throwsA(DomainError.unexpected));
  });
}