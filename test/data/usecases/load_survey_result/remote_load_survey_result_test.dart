import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/models.dart';

class RemoteLoadSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveyResult({
    required this.url,
    required this.httpClient
  });

  Future<SurveyResultEntity > loadBySurvey({required String surveyId}) async {
    try {
      final json = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
        ? DomainError.accessDenied
        : DomainError.unexpected;
    }
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
  void mockRequestError(HttpError error) => mockRequestCall().thenThrow(error);

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

  Map makeInvalidJson() => {
    'invalid_key': 'invalid_value'
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

  test('4 - Should return surveyResult on 200', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, SurveyResultEntity(
      surveyId: surveyResult['surveyId'],
      question: surveyResult['question'],
      answers: [
        SurveyAnswerEntity(
          image: surveyResult['answers'][0]['image'],
          answer: surveyResult['answers'][0]['answer'],
          isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
          percent: surveyResult['answers'][0]['percent'],
        ),
        SurveyAnswerEntity(
          answer: surveyResult['answers'][1]['answer'],
          isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
          percent: surveyResult['answers'][1]['percent'],
        )
      ]
    ));
  });

  test('5 - Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockRequest(makeInvalidJson());

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });


  test('6 - Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockRequestError(HttpError.forbidden);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('7 - Should throw UnexpectedError if HttpClient returns 404', () async {
    mockRequestError(HttpError.notFound);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('8 - Should throw UnexpectedError if HttpClient returns 500', () async {
    mockRequestError(HttpError.serverError);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}