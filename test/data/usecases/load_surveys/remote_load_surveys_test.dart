import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/models.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({
    required this.url,
    required this.httpClient
  });

  Future<List<SurveyEntity>> load() async {
    final httpResponse = await httpClient.request(url: url, method: 'get');
    return httpResponse.map<SurveyEntity>((json) => RemoteSurveyModel.fromJson(json).toEntity()).toList();
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteLoadSurveys sut;
  late HttpClientSpy httpClient;
  late String url;
  late List<Map> list;

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
    list = makeSurveyList();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    mockRequest(list);
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
  });

  test('1 - Should call HttpClient with correct values', () async {
    await sut.load();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

    test('2 - Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        dateTime: DateTime.parse(list[0]['date']),
        didAnswer: list[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        dateTime: DateTime.parse(list[1]['date']),
        didAnswer: list[1]['didAnswer'],
      )
    ]);
  });
}