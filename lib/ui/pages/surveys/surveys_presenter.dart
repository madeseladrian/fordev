import 'package:flutter/material.dart';

import 'survey_view_model.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String?> get navigateToStream;

  Future<void> loadData();
  void goToSurveyResult(String surveyId);
}