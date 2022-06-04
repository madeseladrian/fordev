import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../presentation/helpers/helpers.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter extends GetxController implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel?>(null);
  final _isSessionExpired = Rx<bool>(false);

  @override
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;
  @override
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  @override
  Future<void> loadData() async {
    try {
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.subject.add(surveyResult.toViewModel());
    } on DomainError catch(error) {
      if (error == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } 
  }

  @override
  Future<void> save({required String answer}) async {
    
  }
}