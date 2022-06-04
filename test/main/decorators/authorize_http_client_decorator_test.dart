import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';

import 'package:fordev/main/decorators/decorators.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}
class DeleteSecureCacheStorageSpy extends Mock implements DeleteSecureCacheStorage {}
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late AuthorizeHttpClientDecorator sut;
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late DeleteSecureCacheStorageSpy deleteSecureCacheStorage;
  late HttpClientSpy httpClient;
  late String url;
  late String method;
  late Map body;
  late String token;
  late String httpResponse;

  When mockRequestCall() => when(() => httpClient.request(
    url: any(named: 'url'),
    method: any(named: 'method'),
    body: any(named: 'body'),
    headers: any(named: 'headers')
  ));
  void mockRequest(dynamic data) => mockRequestCall().thenAnswer((_) async => data);
  void mockRequestError(HttpError error) => mockRequestCall().thenThrow(error);

  When mockFetchCall() => when(() => fetchSecureCacheStorage.fetchSecure(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => deleteSecureCacheStorage.deleteSecure(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);

  setUp(() {
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    token = faker.guid.guid();
    httpResponse = faker.randomGenerator.string(50);
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    mockFetch(token);
    deleteSecureCacheStorage = DeleteSecureCacheStorageSpy();
    mockDelete();
    httpClient = HttpClientSpy();
    mockRequest(httpResponse);
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      deleteSecureCacheStorage: deleteSecureCacheStorage,
      decoratee: httpClient
    );
  });

  test('1 - Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('2 - Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(() => httpClient.request(
      url: url, 
      method: method, 
      body: body, 
      headers: {'x-access-token': token})
    ).called(1);

    await sut.request(
      url: url, 
      method: method, 
      body: body, 
      headers: {'any_header': 'any_value'}
    );
    verify(() => httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token, 'any_header': 'any_value'}
    )).called(1);
  });

  test('3 - Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });

  test('4 - Should rethrow if decoratee throws', () async {
    mockRequestError(HttpError.badRequest);

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });

  test('5 - Should throw ForbiddenError if FetchSecureCacheStorage throws', () async {
    mockFetchError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(() => deleteSecureCacheStorage.deleteSecure('token')).called(1);
  });

}