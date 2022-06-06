import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/ui/pages/pages.dart';

class ApiPresenter {
  static SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) => SurveyResultViewModel(
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
}