import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

Widget makeSurveyResultPage() {
  return SurveyResultPage(presenter: SurveyResultPresenterSpy());
}