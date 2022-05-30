import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

class AuthorizeHttpClientDecorator  {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
  });

  Future<dynamic> request() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

void main() {
  late AuthorizeHttpClientDecorator sut;
  late FetchSecureCacheStorageSpy secureCacheStorage;
  late String token;


  When mockFetchCall() => when(() => secureCacheStorage.fetchSecure(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);

  setUp(() {
    token = faker.guid.guid();
    secureCacheStorage = FetchSecureCacheStorageSpy();
    mockFetch(token);
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: secureCacheStorage,
    );
  });

  test('1 - Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request();

    verify(() => secureCacheStorage.fetchSecure('token')).called(1);
  });
}