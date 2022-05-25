import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  When mockGetCall() => when(() => client.get(any(), headers: any(named: 'headers')));
  void mockGet(int statusCode, {String body = '{"any_key":"any_value"}'}) => 
    mockGetCall().thenAnswer((_) async => Response(body, statusCode));

  When mockPostCall() => when(() => 
    client.post(
      any(),
      headers: any(named: 'headers'),
      body: any(named: 'body')
    ));
  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) => 
    mockPostCall().thenAnswer((_) async => Response(body, statusCode));
  void mockPostError() => when(() => mockPostCall().thenThrow(Exception()));

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    mockGet(200);
    mockPost(200);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('get', () {
    test('1,2 - Should call get with correct values', () async {
      await sut.request(url: url, method: 'get');
      verify(() => client.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        }
      ));
    });

    test('3 - Should return data if get returns 200', () async {
      final response = await sut.request(url: url, method: 'get');

      expect(response, {'any_key': 'any_value'});
    });

    test('4 - Should return null if get returns 200 with no data', () async {
      mockGet(200, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

  });

  group('post', () {
    test('1,2,3 - Should call post with correct values', () async { 
      sut.request(url: url, method: 'post', body: {"any_key":"any_value"});
      verify(() => client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: '{"any_key":"any_value"}'
      ));
    });

    test('4 - Should return data if post returns 200', () async { 
      final response = await sut.request(url: url, method: 'post');
      expect(response, {"any_key":"any_value"});
    });

    test('5 - Should return null if post returns 200 with no data', () async {
      mockPost(200, body: ''); 
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('6 - Should return null if post returns 204', () async {
      mockPost(204, body: ''); 
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });
    
    test('7 - Should return null if post returns 204 with data', () async {
      mockPost(204); 
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    // Tests with body is not necessary, because it is the same as without body
    test('8 - Should return BadRequestError if post returns 400 with body', () async {
      mockPost(400, body: ''); 
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('9 - Should return BadRequestError if post returns 400', () async {
      mockPost(400); 
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('10 - Should return UnauthorizedError if post returns 401', () async {
      mockPost(401); 
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('11 - Should return ForbiddenError if post returns 403', () async {
      mockPost(403); 
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('12 - Should return NotFoundError if post returns 404', () async {
      mockPost(404); 
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });

    test('13 - Should return ServerError if post returns 500', () async {
      mockPost(500); 
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });

    // Is an error different from the others
    test('14 - Should return ServerError if post throws with 422', () async {
      mockPost(422); 
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });

    test('15 - Should return ServerError if post throws', () async {
      mockPostError(); 
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('shared', () {
    test('* - Should throw ServerError if invalid method is provided', () {
      final future = sut.request(url: url, method: 'invalid_method');
      expect(() => future, throwsA(HttpError.serverError));
    });
  });
}