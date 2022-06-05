import '../../../../domain/usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';
import 'package:mockito/mockito.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) {
  return GetxSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
    saveSurveyResult: SaveSurveyResultSpy(),
    surveyId: surveyId
  );
}