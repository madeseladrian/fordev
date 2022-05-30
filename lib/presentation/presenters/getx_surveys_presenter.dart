import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController  {
  final LoadSurveys loadSurveys;
  
  final _isLoading = false.obs;
  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({required this.loadSurveys});

  Future<void> loadData() async {
    _isLoading.value = true;
    final surveys = await loadSurveys.load();
    _surveys.value = surveys.map((survey) => SurveyViewModel(
      id: survey.id, 
      question: survey.question, 
      date: DateFormat('dd MMM yyyy').format(survey.dateTime),
      didAnswer: survey.didAnswer)
    ).toList();
    _isLoading.value = false;
  }
}