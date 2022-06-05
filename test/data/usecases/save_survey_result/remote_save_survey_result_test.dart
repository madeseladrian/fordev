import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';

class RemoteSaveSurveyResult  {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({
    required this.url,
    required this.httpClient
  });

  Future<void> save({required String answer}) async {
    await httpClient.request(url: url, method: 'put', body: {'answer': answer});
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteSaveSurveyResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late String answer;
  late Map surveyResult;

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
    answer = faker.lorem.sentence();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    mockRequest(surveyResult);
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
  });

  test('1 - Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(() => httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });
}