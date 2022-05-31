import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final LocalLoadSurveys local;
  final RemoteLoadSurveys remote;

  RemoteLoadSurveysWithLocalFallback({
    required this.local,
    required this.remote
  });

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();
      await local.save(surveys);
      return surveys;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
      await local.validate();
      return await local.load();
    }
  }
}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}
class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late LocalLoadSurveysSpy local;
  late RemoteLoadSurveysSpy remote;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  When mockLocalSaveCall() => when(() => local.save(any()));
  void mockLocalSave() => mockLocalSaveCall().thenAnswer((_) async => _);

  When mockLocalValidateCall() => when(() => local.validate());
  void mockLocalValidate() => mockLocalValidateCall().thenAnswer((_) async => _);

  When mockLocalLoadCall() => when(() => local.load());
  void mockLocalLoad(List<SurveyEntity> surveys) => mockLocalLoadCall().thenAnswer((_) async => surveys);
  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  When mockRemoteLoadCall() => when(() => remote.load());
  void mockRemoteLoad(List<SurveyEntity> surveys) => mockRemoteLoadCall().thenAnswer((_) async => surveys);
  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  List<SurveyEntity> makeSurveyList() => [
    SurveyEntity(
      id: faker.guid.guid(),
      question: faker.randomGenerator.string(10),
      dateTime: DateTime.utc(2020, 2, 2),
      didAnswer: true
    ),
    SurveyEntity(
      id: faker.guid.guid(),
      question: faker.randomGenerator.string(10),
      dateTime: DateTime.utc(2018, 12, 20),
      didAnswer: false
    )
  ];

  setUp(() {
    localSurveys = makeSurveyList();
    local = LocalLoadSurveysSpy();
    mockLocalSave();
    mockLocalValidate();
    mockLocalLoad(localSurveys);
    remoteSurveys = makeSurveyList();
    remote = RemoteLoadSurveysSpy();
    mockRemoteLoad(remoteSurveys);
    sut = RemoteLoadSurveysWithLocalFallback(
      local: local,
      remote: remote
    );
  });

  test('1 - Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test('2 - Should call local save with remote data', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test('3 - Should return remote surveys', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('4 - Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('5,6 - Should call local load on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });

  test('7 - Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('8 - Should throw UnexpectedError if remote and local throws', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}