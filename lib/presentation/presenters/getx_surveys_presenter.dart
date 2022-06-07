import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';

import '../mixins/mixins.dart';

class GetxSurveysPresenter extends GetxController 
with SessionManager, NavigationManager
implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  
  final _surveys = Rx<List<SurveyViewModel>>([]);

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({required this.loadSurveys});

  @override
  Future<void> loadData() async {
    try {
      final surveys = await loadSurveys.load();
      _surveys.value = surveys.map((survey) => SurveyViewModel(
        id: survey.id, 
        question: survey.question, 
        date: DateFormat('dd MMM yyyy').format(survey.dateTime),
        didAnswer: survey.didAnswer)
      ).toList();
    } on DomainError catch (error, staceTrack) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveys.subject.addError(UIError.unexpected.description, staceTrack);
      }
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    navigateTo = '/survey_result/$surveyId';
  }
}