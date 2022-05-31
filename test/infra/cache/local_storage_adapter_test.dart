import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  late LocalStorageAdapter sut;
  late LocalStorageSpy localStorage;
  late String key;
  late dynamic value;

  When mockSaveCall() => when(() => localStorage.setItem(any(), any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
    void mockSaveError() => when(() => mockSaveCall().thenThrow(Exception()));

  When mockDeleteCall() => when(() => localStorage.deleteItem(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => when(() => mockDeleteCall().thenThrow(Exception()));

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    mockSave();
    mockDelete();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('save', () {
    test('1,2 - Should call localStorage with correct delete and set values', () async {
      await sut.save(key: key, value: value);

      verify(() => localStorage.deleteItem(key)).called(1);
      verify(() => localStorage.setItem(key, value)).called(1);
    });

    test('3 - Should throw if deleteItem throws', () async {
      mockDeleteError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });

    test('4 - Should throw if setItem throws', () async {
      mockSaveError();
      
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('1 - Should call localStorage with correct delete value', () async {
      await sut.delete(key);

      verify(() => localStorage.deleteItem(key)).called(1);
    });

    test('2 - Should throw if deleteItem throws', () async {
      mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}