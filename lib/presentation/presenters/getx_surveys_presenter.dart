import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  
  final _isLoading = false.obs;
  final _surveys = Rx<List<SurveyViewModel>>([]);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({required this.loadSurveys});

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys.map((survey) => SurveyViewModel(
        id: survey.id, 
        question: survey.question, 
        date: DateFormat('dd MMM yyyy').format(survey.dateTime),
        didAnswer: survey.didAnswer)
      ).toList();
    } on DomainError catch (_, stackTrace) {
      _surveys.subject.addError(UIError.unexpected.description, stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }
}