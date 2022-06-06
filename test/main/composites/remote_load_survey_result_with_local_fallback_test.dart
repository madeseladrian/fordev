import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/main/composites/composites.dart';
import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late String surveyId;
  late SurveyResultEntity remoteSurveyResult;
  late SurveyResultEntity localSurveyResult;

  setUp(() {
    surveyId = faker.guid.guid();
    localSurveyResult = EntityFactory.makeSurveyResult();
    local = LocalLoadSurveyResultSpy();
    local.mockLoad(localSurveyResult);
    remoteSurveyResult = EntityFactory.makeSurveyResult();
    remote = RemoteLoadSurveyResultSpy();
    remote.mockLoad(remoteSurveyResult);
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local
    );
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
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
    remote.mockLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('5,6 - Should call local loadBySurvey on remote error', () async {
    remote.mockLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('7 - Should return local surveyResult', () async {
    remote.mockLoadError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localSurveyResult);
  });

  test('8 - Should throw UnexpectedError if remote and local loadBySurvey throws', () async {
    remote.mockLoadError(DomainError.unexpected);
    local.mockLoadError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}