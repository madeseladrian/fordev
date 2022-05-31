import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

class LocalStorageAdapter  {
  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}

void main() {
  late LocalStorageAdapter sut;
  late LocalStorageSpy localStorage;
  late String key;
  late dynamic value;

  When mockSaveCall() => when(() => localStorage.setItem(any(), any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);

  When mockDeleteCall() => when(() => localStorage.deleteItem(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    mockSave();
    mockDelete();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('save', () {
    test('1,2 - Should call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => localStorage.deleteItem(key)).called(1);
      verify(() => localStorage.setItem(key, value)).called(1);
    });
  });
}