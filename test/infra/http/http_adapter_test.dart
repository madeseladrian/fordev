import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter  {
  final Client client;

  HttpAdapter({required this.client});

  Future<void> request({
    required String url
  }) async {
    await client.post(Uri.parse(url));
  }
}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  When mockPostCall() => when(() => 
    client.post(any()));

  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) => 
    mockPostCall().thenAnswer((_) async => Response(body, statusCode));

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
    test('1 - Should call post with correct values', () async { 
      sut.request(url: url);
      verify(() => client.post(
        Uri.parse(url)
      ));
    });
  });
}