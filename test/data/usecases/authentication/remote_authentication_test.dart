import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/params/params.dart';

abstract class HttpClient{
  Future<dynamic> request({
    required String url
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

class RemoteAuthentication {
  final String url;
  final HttpClient httpClient;

  RemoteAuthentication({required this.url, required this.httpClient});

  Future<void> authenticate(AuthenticationParams params) async {
    await httpClient.request(url: url);
  }
}

void main() {
  late String url;
  late HttpClientSpy httpClient;
  late RemoteAuthentication sut;
  late Map apiResult;
  late AuthenticationParams params;

  When mockRequestCall() => when(() => httpClient.request(
    url: any(named: 'url')
  ));

  void mockRequest(dynamic data) => 
    mockRequestCall().thenAnswer((_) async => data);

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
 
  test('1 - Should call HttpClient with correct url', () async {
    await sut.authenticate(params);
    verify(() => httpClient.request(url: url));
  });
}