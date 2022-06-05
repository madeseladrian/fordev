import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

class LocalLoadSurveyResult  {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({ required this.cacheStorage });

  Future<void> loadBySurvey({ required String surveyId }) async {
    await cacheStorage.fetch('survey_result/$surveyId');
  }
}

void main() {
  late LocalLoadSurveyResult sut;
  late CacheStorageSpy cacheStorage;
  late Map data;
  late String surveyId;

  When mockFetchCall() => when(() => cacheStorage.fetch(any()));
  void mockFetch(dynamic json) => mockFetchCall().thenAnswer((_) async => json);

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

  setUp(() {
    surveyId = faker.guid.guid();
    data = makeSurveyResult();
    cacheStorage = CacheStorageSpy();
    mockFetch(data);
    sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
  });

  group('loadBySurvey', () {
    test('1 - Should call cacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });
  });
}