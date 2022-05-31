import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';

import 'package:fordev/data/models/models.dart';

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
  Future<void> delete(String key);
  Future<void> save({ required String key, required dynamic value });
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({ required this.fetchCacheStorage });

  Future<List<SurveyEntity>> load() async {
    final data = await fetchCacheStorage.fetch('surveys');
    try {
      if (data?.isEmpty == true) {
        throw Exception();
      }
      return data.map<SurveyEntity>(
        (json) => LocalSurveyModel.fromJson(json).toEntity()
      ).toList();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

void main() {
  late LocalLoadSurveys sut;
  late FetchCacheStorageSpy fetchCacheStorage;
  late List<Map> data;

  When mockFetchCall() => when(() => fetchCacheStorage.fetch(any()));
  void mockFetch(dynamic json) => mockFetchCall().thenAnswer((_) async => json);

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

  setUp(() {
    data = makeSurveyList();
    fetchCacheStorage = FetchCacheStorageSpy();
    mockFetch(data);
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
  });

  group('load', () {
    test('1 - Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(() => fetchCacheStorage.fetch('surveys')).called(1);
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
  });
}