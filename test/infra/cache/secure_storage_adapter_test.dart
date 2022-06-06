import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

import '../mocks/mocks.dart';

void main() {
  late SecureStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;
  late String key;
  late String value;

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();
    secureStorage = FlutterSecureStorageSpy();
    secureStorage.mockFetch(value);
    sut = SecureStorageAdapter(secureStorage: secureStorage);
  });

  group('saveSecure', () {
    test('1 - Should call save secure with correct values', () async {
      await sut.save(key: key, value: value);
      verify(() => secureStorage.write(key: key, value: value));
    });

    test('2 - Should throw if save secure throws', () async {
      secureStorage.mockSaveError();
      final future = sut.save(key: key, value: value);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('1 - Should call save secure with correct value', () async {
      await sut.fetch(key);
      verify(() => secureStorage.read(key: key));
    });

    test('2 - Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(value);
      expect(fetchedValue, value);
    });

    test('3 - Should throw if fetch secure throws', () async {
      secureStorage.mockFetchError();
      final future = sut.fetch(key);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('1 - Should call delete with correct key', () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test('2 - Should throw if delete throws', () async {
      secureStorage.mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}