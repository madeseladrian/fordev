import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late String key;
  late dynamic value;
  late SecureStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;

  When mockSaveCall() => when(() => 
    secureStorage.write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => when(() => mockSaveCall().thenThrow(Exception()));
  
  When mockFetchCall() => when(() => secureStorage.read(key: any(named: 'key')));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => when(() => mockFetchCall().thenThrow(Exception()));
  
  When mockDeleteCall() => when(() => secureStorage.delete(key: any(named: 'key')));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();
    secureStorage = FlutterSecureStorageSpy();
    mockSave();
    mockFetch(key);
    mockDelete();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
  });

  group('saveSecure', () {
    test('1 - Should call save secure with correct values', () async {
      await sut.save(key: key, value: value);
      verify(() => secureStorage.write(key: key, value: value));
    });

    test('2 - Should throw if save secure throws', () async {
      mockSaveError();
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
      final fetchedValue = await sut.fetch(key);
      expect(fetchedValue, key);
    });

    test('3 - Should throw if fetch secure throws', () async {
      mockFetchError();
      final future = sut.fetch(key);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('1 - Should call delete with correct key', () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });
  });
}