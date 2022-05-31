import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:fordev/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  late SurveyResultPresenterSpy presenter;
  late StreamController<bool> isLoadingController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    isLoadingController = StreamController<bool>();

    when(() => presenter.loadData()).thenAnswer((_) async => _);
    when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream); 

    final surveyResultPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(
          name: '/survey_result/any_survey_id',
          page: () => SurveyResultPage(presenter: presenter),
        ),
      ],
    );
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveyResultPage);
    });
  }

  tearDown(() {
    isLoadingController.close();
  });

  testWidgets('1 - Should call LoadSurveyResult on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('2,3 - Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}