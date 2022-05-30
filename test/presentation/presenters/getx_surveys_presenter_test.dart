import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  late GetxSurveysPresenter sut;
  late LoadSurveysSpy loadSurveys;
  late List<SurveyEntity> surveys;

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

  When mockLoadCall() => when(() => loadSurveys.load());
  void mockLoad(List<SurveyEntity> surveys) => mockLoadCall().thenAnswer((_) async => surveys);
  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);

  setUp(() {
    surveys = makeSurveyList();
    loadSurveys = LoadSurveysSpy();
    mockLoad(surveys);
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
  });

  test('1 - Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
  });

  test('2,3,4 - Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
      SurveyViewModel(id: surveys[0].id, question: surveys[0].question, date: '02 Feb 2020', didAnswer: surveys[0].didAnswer),
      SurveyViewModel(id: surveys[1].id, question: surveys[1].question, date: '20 Dec 2018', didAnswer: surveys[1].didAnswer),
    ])));

    await sut.loadData();
  });

  test('5 - Should emit correct events on failure', () async {
    mockLoadError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(
      null, 
      onError: expectAsync2((error, _) => expect(error, UIError.unexpected.description))
    );

    await sut.loadData();
  });
}