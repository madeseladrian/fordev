import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}
class HttpClientSpy extends Mock implements HttpClient {}

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.decoratee
  });

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = headers ?? {}..addAll({'x-access-token': token});
      return await decoratee.request(
        url: url, 
        method: method, 
        body: body, 
        headers: authorizedHeaders
      );
    } on HttpError {
      rethrow;
    } catch (error) {
      throw HttpError.forbidden;
    }
  }
}

void main() {
  late AuthorizeHttpClientDecorator sut;
  late FetchSecureCacheStorageSpy secureCacheStorage;
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

  When mockFetchCall() => when(() => secureCacheStorage.fetchSecure(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    token = faker.guid.guid();
    httpResponse = faker.randomGenerator.string(50);
    secureCacheStorage = FetchSecureCacheStorageSpy();
    mockFetch(token);
    httpClient = HttpClientSpy();
    mockRequest(httpResponse);
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: secureCacheStorage,
      decoratee: httpClient
    );
  });

  test('1 - Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => secureCacheStorage.fetchSecure('token')).called(1);
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

  test('4 - Should throw ForbiddenError if FetchSecureCacheStorage throws', () async {
    mockFetchError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
  });

  test('5 - Should rethrow if decoratee throws', () async {
    mockRequestError(HttpError.badRequest);

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });
}