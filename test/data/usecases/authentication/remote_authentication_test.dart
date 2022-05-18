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
  late RemoteAuthentication sut;
  late Map apiResult;
  late AuthenticationParams params;

  When mockRequestCall() => when(() => httpClient.request(
    url: any(named: 'url'),
    method: any(named: 'method'),
    body: any(named: 'body')
  ));
  void mockRequest(dynamic data) => 
    mockRequestCall().thenAnswer((_) async => data);
  void mockError(HttpError error) => mockRequestCall().thenThrow(error);

  setUp(() {
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password()
    );
    apiResult = {"accessToken": faker.guid.guid()};
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    mockRequest(apiResult);
    sut = RemoteAuthentication(url: url, httpClient: httpClient);
  });
 
  test('1,2,3 - Should call HttpClient with correct values', () async {
    await sut.authenticate(params);
    verify(() => httpClient.request(
      url: url,
      method: 'post',
      body: {"email": params.email, "password": params.password}
    ));
  });

  test('4 - Should return an Account if HttpClient returns 200', () async {
    final account = await sut.authenticate(params);
    expect(account.token, apiResult['accessToken']);
  });

  test('5 - Should throw UnexpectedError if HttpClient returns 400', () async {
    mockError(HttpError.badRequest);
    final future = sut.authenticate(params);
    expect(future, throwsA(DomainError.unexpected));
  });
}