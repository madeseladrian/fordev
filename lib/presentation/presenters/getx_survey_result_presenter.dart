import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../presentation/helpers/helpers.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter extends GetxController implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _isLoading = false.obs;
  final _surveyResult = Rx<SurveyResultViewModel?>(null);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  @override
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.subject.add(surveyResult.toViewModel());
    } on DomainError {
      _surveyResult.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> save({required String answer}) async {
    
  }
}