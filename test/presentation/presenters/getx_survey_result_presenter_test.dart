import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

void main() {
  late GetxSurveyResultPresenter sut;
  late LoadSurveyResultSpy loadSurveyResult;
  late SurveyResultEntity loadResult;
  late String surveyId;

  When mockLoadCall() => when(() => loadSurveyResult.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity surveyResult) => mockLoadCall().thenAnswer((_) async => surveyResult);
  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);

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

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) => SurveyResultViewModel(
    surveyId: entity.surveyId,
    question: entity.question,
    answers: [
      SurveyAnswerViewModel(
        image: entity.answers[0].image,
        answer: entity.answers[0].answer,
        isCurrentAnswer: entity.answers[0].isCurrentAnswer,
        percent: '${entity.answers[0].percent}%'
      ),
      SurveyAnswerViewModel(
        answer: entity.answers[1].answer,
        isCurrentAnswer: entity.answers[1].isCurrentAnswer,
        percent: '${entity.answers[1].percent}%'
      )
    ]
  );

  setUp(() {
    loadResult = makeSurveyResult();
    surveyId = faker.guid.guid();
    loadSurveyResult = LoadSurveyResultSpy();
    mockLoad(loadResult);

    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId
    );
  });

  group('loadData', () {
    test('1 - Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('2,3,4 - Should emit correct events on success', () async {
      sut.surveyResultStream.listen(expectAsync1((result) => expect(result, mapToViewModel(loadResult))));

      await sut.loadData();
    });

    test('5 - Should emit correct events on failure', () async {
      mockLoadError(DomainError.unexpected);

      //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => 
        expect(error, UIError.unexpected.description)
      ));

      await sut.loadData();
    });

    test('6 - Should emit correct events on access denied', () async {
      mockLoadError(DomainError.accessDenied);

      //expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });
}