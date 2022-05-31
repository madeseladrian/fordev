import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';

class RemoteLoadSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveyResult({
    required this.url,
    required this.httpClient
  });

  Future<void> loadBySurvey({required String surveyId}) async {
    await httpClient.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteLoadSurveyResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late Map surveyResult;
  late String surveyId;

  When mockRequestCall() => when(() => httpClient.request(
    url: any(named: 'url'),
    method: any(named: 'method'),
    body: any(named: 'body'),
    headers: any(named: 'headers')
  ));
  void mockRequest(dynamic data) => mockRequestCall().thenAnswer((_) async => data);

  Map makeSurveyResultJson() => {
    'surveyId': faker.guid.guid(),
    'question': faker.randomGenerator.string(50),
    'answers': [{
      'image': faker.internet.httpUrl(),
      'answer': faker.randomGenerator.string(20),
      'percent': faker.randomGenerator.integer(100),
      'count': faker.randomGenerator.integer(1000),
      'isCurrentAccountAnswer': faker.randomGenerator.boolean()
    }, {
      'answer': faker.randomGenerator.string(20),
      'percent': faker.randomGenerator.integer(100),
      'count': faker.randomGenerator.integer(1000),
      'isCurrentAccountAnswer': faker.randomGenerator.boolean()
    }],
    'date': faker.date.dateTime().toIso8601String(),
  };

  setUp(() {
    surveyResult = makeSurveyResultJson();
    surveyId = faker.guid.guid();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    mockRequest(surveyResult);
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
  });

  test('1,2,3 - Should call HttpClient with correct values', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => httpClient.request(url: url, method: 'get'));
  });
}