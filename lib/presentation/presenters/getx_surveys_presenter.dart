import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  
  final _surveys = Rx<List<SurveyViewModel>>([]);
  final _navigateTo = Rx<String>('');

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;
  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

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
    } on DomainError catch (error, stackTrace){
      _surveys.subject.addError(UIError.unexpected.description, stackTrace);
    } 
  }

  @override
  void goToSurveyResult(String surveyId) {
    _navigateTo.value = '/survey_result/$surveyId';
  }
}