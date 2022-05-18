import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter  {
  final Client client;

  HttpAdapter({required this.client});

  Future<Map?> request({
    required String url,
    required String method,
    Map? body
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json'
    };
    var response = Response('', 500);
    try {
      response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body
      );
    } catch (error) {
      throw HttpError.serverError;
    }
    
    return _handleResponse(response);
  }

  Map? _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    } 
  }
}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

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
    mockPost(200);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('post', () {
    test('1,2,3 - Should call post with correct values', () async { 
      sut.request(url: url, method: 'post', body: {"any_key":"any_value"});
      verify(() => client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: {"any_key":"any_value"}
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
}