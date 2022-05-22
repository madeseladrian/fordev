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

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();
    secureStorage = FlutterSecureStorageSpy();
    mockSave();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
  });

  group('saveSecure', () {
    test('1 - Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);
      verify(() => secureStorage.write(key: key, value: value));
    });
  });
}