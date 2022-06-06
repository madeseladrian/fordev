import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/usecases/usecases.dart';
import '../../mocks/mocks.dart';

void main() {
  late LocalSaveCurrentAccount sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late AccountEntity account;

  setUp(() {
    secureCacheStorage = SecureCacheStorageSpy();
    account = AccountEntity(token: faker.guid.guid());
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: secureCacheStorage);
  });

  test('1 - Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(() => secureCacheStorage.save(
      key: 'token', value: account.token
    ));
  });

  test('2 - Should throw UnexpectedError if SaveSecureCacheStorage throws', () async {
    secureCacheStorage.mockSaveError();
    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}