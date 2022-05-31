import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class CacheStorage {
  Future<dynamic> fetch(String key);
  Future<void> delete(String key);
  Future<void> save({ required String key, required dynamic value });
}

class CacheStorageSpy extends Mock implements CacheStorage {}

class LocalLoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({ required this.cacheStorage });

  Future<void> load() async {
    await cacheStorage.fetch('surveys');
  }
}

void main() {
  late LocalLoadSurveys sut;
  late CacheStorageSpy cacheStorage;
  late List<Map> data;

  When mockFetchCall() => when(() => cacheStorage.fetch(any()));
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

  setUp(() {
    data = makeSurveyList();
    cacheStorage = CacheStorageSpy();
    mockFetch(data);
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
  });

  group('load', () {
    test('1 - Should call cacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });
  });
}