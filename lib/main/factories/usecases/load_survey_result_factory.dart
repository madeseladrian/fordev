import '../../../data/usecases/usecases.dart';
import '../factories.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results')
  );
}
