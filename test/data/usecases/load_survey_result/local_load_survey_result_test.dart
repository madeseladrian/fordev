import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/models/models.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

class LocalLoadSurveyResult  {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({ required this.cacheStorage });

  Future<SurveyResultEntity> loadBySurvey({ required String surveyId }) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete('survey_result/$surveyId');
    }
  }
}

void main() {
  late LocalLoadSurveyResult sut;
  late CacheStorageSpy cacheStorage;
  late Map data;
  late String surveyId;

  When mockFetchCall() => when(() => cacheStorage.fetch(any()));
  void mockFetch(dynamic json) => mockFetchCall().thenAnswer((_) async => json);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

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

  setUp(() {
    surveyId = faker.guid.guid();
    data = makeSurveyResult();
    cacheStorage = CacheStorageSpy();
    mockFetch(data);
    mockDelete();
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
  });
}