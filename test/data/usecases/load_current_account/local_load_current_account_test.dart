import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  When mockFetchCall() => when(() => fetchSecureCacheStorage.fetchSecure(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());
  
  setUp(() {
    token = faker.guid.guid();
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    mockFetch(token);
  });
 
  test('1 - Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();
    verify(() => fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('2 - Should return an AccountEntity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token: token));
  });

  test('3 - Should throw UnexpectedError if FetchSecureCacheStorage throws', () async {
    mockFetchError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
  
  test('4 - Should throw UnexpectedError if FetchSecureCacheStorage returns null', () async {
    mockFetch(null);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}