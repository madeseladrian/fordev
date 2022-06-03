import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/helpers/helpers.dart';

import 'package:fordev/ui/pages/pages.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class GetxSurveyResultPresenter extends GetxController {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _isLoading = false.obs;
  final _surveyResult = Rx<SurveyResultViewModel?>(null);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  Future<void> loadData() async {
    _isLoading.value = true;
    final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
    _surveyResult.subject.add(surveyResult.toViewModel());
    _isLoading.value = false;
  }
}

void main() {
  late GetxSurveyResultPresenter sut;
  late LoadSurveyResultSpy loadSurveyResult;
  late SurveyResultEntity loadResult;
  late String surveyId;

  When mockLoadCall() => when(() => loadSurveyResult.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity surveyResult) => mockLoadCall().thenAnswer((_) async => surveyResult);

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

    test('2,3 - Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(result, mapToViewModel(loadResult))));

      await sut.loadData();
    });

  });
}