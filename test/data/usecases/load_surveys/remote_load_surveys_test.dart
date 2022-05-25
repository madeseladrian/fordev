import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/http/http.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({
    required this.url,
    required this.httpClient
  });

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteLoadSurveys sut;
  late HttpClientSpy httpClient;
  late String url;

  When mockRequestCall() => when(() => httpClient.request(
    url: any(named: 'url'),
    method: any(named: 'method'),
    body: any(named: 'body'),
  ));
  void mockRequest(dynamic data) => mockRequestCall().thenAnswer((_) async => data);

  List<Map> makeSurveyList() => [{
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(50),
    'didAnswer': faker.randomGenerator.boolean(),
    'date': faker.date.dateTime().toIso8601String(),
  }, {
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(50),
    'didAnswer': faker.randomGenerator.boolean(),
    'date': faker.date.dateTime().toIso8601String(),
  }];

  setUp(() { 
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    mockRequest(makeSurveyList());
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
  });

  test('1 - Should call HttpClient with correct values', () async {
    await sut.load();

    verify(() => httpClient.request(url: url, method: 'get'));
  });
}