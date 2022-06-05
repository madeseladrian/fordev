import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  late LocalLoadSurveyResult sut;
  late CacheStorageSpy cacheStorage;
  late Map data;
  late String surveyId;
  late SurveyResultEntity surveyResult;

  When mockFetchCall() => when(() => cacheStorage.fetch(any()));
  void mockFetch(dynamic json) => mockFetchCall().thenAnswer((_) async => json);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockSaveCall() => when(() => cacheStorage.save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => cacheStorage.delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);

  Map makeSurveyResult() => {
    'surveyId': faker.guid.guid(),
    'question': faker.lorem.sentence(),
    'answers': [{
      'image': faker.internet.httpUrl(),
      'answer': faker.lorem.sentence(),
      'isCurrentAnswer': 'true',
      'percent': '40'
    }, {
      'answer': faker.lorem.sentence(),
      'isCurrentAnswer': 'false',
      'percent': '60'
    }],
  };

   Map makeInvalidSurveyResult() => {
    'surveyId': faker.guid.guid(),
    'question': faker.lorem.sentence(),
    'answers': [{
      'image': faker.internet.httpUrl(),
      'answer': faker.lorem.sentence(),
      'isCurrentAnswer': 'invalid bool',
      'percent': 'invalid int'
    }],
  };

  Map makeIncompleteSurveyResult() => {
    'surveyId': faker.guid.guid()
  };

  SurveyResultEntity makeSurveyResultEntity() => SurveyResultEntity(
    surveyId: faker.guid.guid(),
    question: faker.lorem.sentence(),
    answers: [
      SurveyAnswerEntity(
        image: faker.internet.httpUrl(),
        answer: faker.lorem.sentence(),
        isCurrentAnswer: true,
        percent: 40
      ),
      SurveyAnswerEntity(
        answer: faker.lorem.sentence(),
        isCurrentAnswer: false,
        percent: 60
      )
    ]
  );

  setUp(() {
    surveyId = faker.guid.guid();
    surveyResult = makeSurveyResultEntity();
    data = makeSurveyResult();
    cacheStorage = CacheStorageSpy();
    mockFetch(data);
    mockDelete();
    mockSave();
    sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
  });

  group('loadBySurvey', () {
    test('1 - Should call cacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('2 - Should return surveyResult on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(surveyResult, SurveyResultEntity(
        surveyId: data['surveyId'],
        question: data['question'],
        answers: [
          SurveyAnswerEntity(
            image: data['answers'][0]['image'],
            answer: data['answers'][0]['answer'],
            percent: 40,
            isCurrentAnswer: true,
          ),
          SurveyAnswerEntity(
            answer: data['answers'][1]['answer'],
            percent: 60,
            isCurrentAnswer: false,
          )
        ]
      ));
    });

    test('3 - Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('4 - Should throw UnexpectedError if cache is isvalid', () async {
      mockFetch(makeInvalidSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('5 - Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(makeIncompleteSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('6 - Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('1 - Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('2 - Should delete cache if validate is invalid', () async {
      mockFetch(makeInvalidSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('3 - Should delete cache if validate is incomplete', () async {
      mockFetch(makeIncompleteSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('4 - Should delete cache if fetch fails', () async {
      mockFetchError();

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    test('1 - Should call cacheStorage with correct values', () async {
      Map json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [{
          'image': surveyResult.answers[0].image,
          'answer': surveyResult.answers[0].answer,
          'percent': '40',
          'isCurrentAnswer': 'true'
        }, {
          'image': null,
          'answer': surveyResult.answers[1].answer,
          'percent': '60',
          'isCurrentAnswer': 'false'
        }]
      };

      await sut.save(surveyResult);

      verify(() => cacheStorage.save(key: 'survey_result/${surveyResult.surveyId}', value: json)).called(1);
    });

    test('2 - Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      final future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}