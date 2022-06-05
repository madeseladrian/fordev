import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<SurveyResultEntity> loadBySurvey({ required String surveyId }) async {
    try {
      final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyResult);
      return surveyResult;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
      await local.validate(surveyId);
      return await local.loadBySurvey(surveyId: surveyId);
    }
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}
class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late String surveyId;
  late SurveyResultEntity remoteSurveyResult;
  late SurveyResultEntity localSurveyResult;

  When mockRemoteLoadCall() => when(() => remote.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockRemoteLoad(SurveyResultEntity surveyResult) => mockRemoteLoadCall().thenAnswer((_) async => surveyResult);
  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  When mockLocalLoadCall() => when(() => local.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity surveyResult) => mockLocalLoadCall().thenAnswer((_) async => surveyResult);

  When mockLocalValidateCall() => when(() => local.validate(any()));
  void mockValidate() => mockLocalValidateCall().thenAnswer((_) async => _);

  When mockLocalSaveCall() => when(() => local.save(any()));
  void mockLocalSave() => mockLocalSaveCall().thenAnswer((_) async => _);

  SurveyResultEntity makeSurveyResult() => SurveyResultEntity(
    surveyId: faker.guid.guid(),
    question: faker.lorem.sentence(),
    answers: [
      SurveyAnswerEntity(
        image: faker.internet.httpUrl(),
        answer: faker.lorem.sentence(),
        isCurrentAnswer: true,
        percent: 40
      ),
      SurveyAnswerEntity(
        answer: faker.lorem.sentence(),
        isCurrentAnswer: false,
        percent: 60
      )
    ]
  );

  setUp(() {
    surveyId = faker.guid.guid();
    localSurveyResult = makeSurveyResult();
    local = LocalLoadSurveyResultSpy();
    mockLoad(localSurveyResult);
    mockValidate();
    mockLocalSave();
    remoteSurveyResult = makeSurveyResult();
    remote = RemoteLoadSurveyResultSpy();
    mockRemoteLoad(remoteSurveyResult);
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local
    );
  });

  setUpAll(() {
    registerFallbackValue(makeSurveyResult());
  });

  test('1 - Should call remote loadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('2 - Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(remoteSurveyResult)).called(1);
  });

  test('3 - Should return remote surveyResult', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteSurveyResult);
  });

  test('4 - Should rethrow if remote loadBySurvey throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('5,6 - Should call local loadBySurvey on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });
}