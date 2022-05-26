import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

Widget makeSurveysPage() => SurveysPage(presenter: SurveysPresenterSpy());