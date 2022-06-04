import '../../../data/usecases/usecases.dart';
import '../factories.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) => RemoteLoadSurveyResult(
  httpClient: makeAuthorizeHttpClientDecorator(),
  url: makeApiUrl('surveys/$surveyId/results')
);
