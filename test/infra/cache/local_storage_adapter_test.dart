import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late String key;
  late dynamic value;
  late LocalStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;

  When mockSaveCall() => when(() => 
    secureStorage.write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => when(() => mockSaveCall().thenThrow(Exception()));
  
  When mockFetchCall() => when(() => secureStorage.read(key: any(named: 'key')));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();
    secureStorage = FlutterSecureStorageSpy();
    mockSave();
    mockFetch(key);
    sut = LocalStorageAdapter(secureStorage: secureStorage);
  });

  group('saveSecure', () {
    test('1 - Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);
      verify(() => secureStorage.write(key: key, value: value));
    });

    test('2 - Should throw if save secure throws', () async {
      mockSaveError();
      final future = sut.saveSecure(key: key, value: value);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('1 - Should call save secure with correct value', () async {
      await sut.fetchSecure(key);
      verify(() => secureStorage.read(key: key));
    });
  });
}