import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

import 'package:fordev/ui/helpers/helpers.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxSurveyResultPresenter sut;
  late LoadSurveyResultSpy loadSurveyResult;
  late SaveSurveyResultSpy saveSurveyResult;
  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;
  late String surveyId;
  late String answer;


  setUp(() {
    saveResult = EntityFactory.makeSurveyResult();
    loadResult = EntityFactory.makeSurveyResult();
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();
    loadSurveyResult = LoadSurveyResultSpy();
    loadSurveyResult.mockLoad(loadResult);
    saveSurveyResult = SaveSurveyResultSpy();
    saveSurveyResult.mockSave(saveResult);
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId
    );
  });

  group('loadData', () {
    test('1 - Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('2,3,4 - Should emit correct events on success', () async {
      sut.surveyResultStream.listen(expectAsync1((result) => 
        expect(result, ApiPresenter.mapToViewModel(loadResult))
      ));

      await sut.loadData();
    });

    test('5 - Should emit correct events on failure', () async {
      loadSurveyResult.mockLoadError(DomainError.unexpected);

      //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => 
        expect(error, UIError.unexpected.description)
      ));

      await sut.loadData();
    });

    test('6 - Should emit correct events on access denied', () async {
      loadSurveyResult.mockLoadError(DomainError.accessDenied);

      //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group('save', () {
    test('7 - Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(() => saveSurveyResult.save(answer: answer)).called(1);
    });

    test('8,9,10 - Should emit correct events on success', () async {
      //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.surveyResultStream, emitsInOrder([
        ApiPresenter.mapToViewModel(loadResult),
        ApiPresenter.mapToViewModel(saveResult),
      ]));

      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('11 - Should emit correct events on failure', () async {
      saveSurveyResult.mockSaveError(DomainError.unexpected);

      //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

      await sut.save(answer: answer);
    });

    test('12 - Should emit correct events on access denied', () async {
      saveSurveyResult.mockSaveError(DomainError.accessDenied);

      //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}