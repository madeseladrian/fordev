import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';

import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveyResult({
    required this.url,
    required this.httpClient
  });

  Future<SurveyResultEntity > loadBySurvey({required String surveyId}) async {
    try {
      final json = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
        ? DomainError.accessDenied
        : DomainError.unexpected;
    }
  }
}