import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback  {
  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallback({
    required this.remote
  });

  Future<void> loadBySurvey({ required String surveyId }) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late String surveyId;
  late SurveyResultEntity remoteSurveyResult;

  When mockLoadCall() => when(() => remote.loadBySurvey(surveyId: any(named: 'surveyId')));
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

  setUp(() {
    surveyId = faker.guid.guid();
    remoteSurveyResult = makeSurveyResult();
    remote = RemoteLoadSurveyResultSpy();
    mockLoad(remoteSurveyResult);
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
    );
  });

  setUpAll(() {
    registerFallbackValue(makeSurveyResult());
  });

  test('1 - Should call remote loadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}