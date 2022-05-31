import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  late LocalLoadSurveys sut;
  late CacheStorageSpy cacheStorage;
  late List<Map> data;
  late List<SurveyEntity> surveys;

  When mockFetchCall() => when(() => cacheStorage.fetch(any()));
  void mockFetch(dynamic json) => mockFetchCall().thenAnswer((_) async => json);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => cacheStorage.delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);

  When mockSaveCall() => when(() => cacheStorage.save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
  
  List<Map> makeSurveyList() => [{
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': '2020-07-20T00:00:00Z',
    'didAnswer': 'false',
  }, {
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': '2019-02-02T00:00:00Z',
    'didAnswer': 'true',
  }];

  List<Map> makeInvalidSurveyList() => [{
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': 'invalid date',
    'didAnswer': 'false',
  }];

  List<Map> makeIncompleteSurveyList() => [{
    'date': '2019-02-02T00:00:00Z',
    'didAnswer': 'false',
  }];

  List<SurveyEntity> makeSurveyEntityList() => [
    SurveyEntity(
      id: faker.guid.guid(),
      question: faker.randomGenerator.string(10),
      dateTime: DateTime.utc(2020, 2, 2),
      didAnswer: true
    ),
    SurveyEntity(
      id: faker.guid.guid(),
      question: faker.randomGenerator.string(10),
      dateTime: DateTime.utc(2018, 12, 20),
      didAnswer: false
    )
  ];

  setUp(() {
    surveys = makeSurveyEntityList();
    data = makeSurveyList();
    cacheStorage = CacheStorageSpy();
    mockFetch(data);
    mockDelete();
    mockSave();
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
  });

  group('load', () {
    test('1 - Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('2 -Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
          id: data[0]['id'], 
          question: data[0]['question'], 
          dateTime: DateTime.utc(2020, 7, 20), 
          didAnswer: false
        ),
        SurveyEntity(
          id: data[1]['id'], 
          question: data[1]['question'], 
          dateTime: DateTime.utc(2019, 2, 2), 
          didAnswer: true
        ),
      ]);
    });

    test('3 - Should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('4 - Should throw UnexpectedError if cache is isvalid', () async {
      mockFetch(makeInvalidSurveyList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('5 - Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(makeIncompleteSurveyList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('6 - Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('1 - Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('2 - Should delete cache if it is invalid', () async {
      mockFetch(makeInvalidSurveyList());

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('3 - Should delete cache if it is incomplete', () async {
      mockFetch(makeIncompleteSurveyList());

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('4 - Should delete cache if fetch fails', () async {
      mockFetchError();

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    test('1 - Should call cacheStorage with correct values', () async {
      final list = [{
        'id': surveys[0].id,
        'question': surveys[0].question,
        'date': '2020-02-02T00:00:00.000Z',
        'didAnswer': 'true',
      }, {
        'id': surveys[1].id,
        'question': surveys[1].question,
        'date': '2018-12-20T00:00:00.000Z',
        'didAnswer': 'false',
      }];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('2 - Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}