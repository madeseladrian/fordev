import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

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
}