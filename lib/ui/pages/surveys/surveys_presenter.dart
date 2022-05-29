import 'package:flutter/material.dart';

import 'survey_view_model.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get loadSurveysStream;

  Future<void> loadData();
}