import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenterSpy presenter;
  late StreamController<bool> isLoadingController;

  Future<void> _testPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    isLoadingController = StreamController<bool>();
    
    when(() => presenter.loadData()).thenAnswer((_) async => _);
    when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter)),
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  testWidgets('1 - Should call LoadSurveys on page load', (WidgetTester tester) async {
    await _testPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('2,3 - Should handle loading correctly', (WidgetTester tester) async {
    await  _testPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}