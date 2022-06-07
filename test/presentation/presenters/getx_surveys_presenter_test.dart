import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late GetxSurveysPresenter sut;
  late LoadSurveysSpy loadSurveys;
  late List<SurveyEntity> surveys;

  setUp(() {
    surveys = EntityFactory.makeSurveyList();
    loadSurveys = LoadSurveysSpy();
    loadSurveys.mockLoad(surveys);
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
  });

  test('1 - Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
  });

  test('2,3,4 - Should emit correct events on success', () async {
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
      SurveyViewModel(id: surveys[0].id, question: surveys[0].question, date: '02 Feb 2020', didAnswer: surveys[0].didAnswer),
      SurveyViewModel(id: surveys[1].id, question: surveys[1].question, date: '20 Dec 2018', didAnswer: surveys[1].didAnswer),
    ])));

    await sut.loadData();
  });

  test('5 - Should emit correct events on failure', () async {
    loadSurveys.mockLoadError(DomainError.unexpected);

    sut.surveysStream.listen(null, onError: expectAsync2((error, staceTrack) => 
      staceTrack != null ? expect(error, UIError.unexpected.description) : null));

    await sut.loadData();
  });

  test('6 - Should go to SurveyResultPage on survey click', () async {
    expectLater(sut.navigateToStream, emitsInOrder([
      '/survey_result/any_route',
      '/survey_result/any_route'
    ]));

    sut.goToSurveyResult('any_route');
    sut.goToSurveyResult('any_route');
  });

  test('7 - Should emit correct events on access denied', () async {
    loadSurveys.mockLoadError(DomainError.accessDenied);

    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });
}