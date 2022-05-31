import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenterSpy presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List<SurveyViewModel>> surveysController;

  final themeData = makeAppTheme();

  List<SurveyViewModel> makeSurveyList() => const [
    SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
    SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
    SurveyViewModel(id: '3', question: 'Question 3', date: 'Date 3', didAnswer: true)
  ];

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
    
    when(() => presenter.loadData()).thenAnswer((_) async => _);
    when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.surveysStream).thenAnswer((_) => surveysController.stream);
    
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter)),
      ],
      theme: themeData,
    );
    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    isLoadingController.close();
    surveysController.close();
  });

  testWidgets('1 - Should call LoadSurveys on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('2 - Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('3 - Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('4 - Should present error if surveysStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('5,6 - Should present list if surveysStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveyList());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('7 - Should present right colors', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveyList());
    await tester.pump();

    final firstContainer = tester.widget<Container>(
      find.byKey(const Key('survey_item_1'))
    );
    final firstDecoration = firstContainer.decoration as BoxDecoration;
    expect(firstDecoration.color, themeData.secondaryHeaderColor);

    final secondContainer = tester.widget<Container>(
      find.byKey(const Key('survey_item_2'))
    );
    final secondDecoration = secondContainer.decoration as BoxDecoration;
    expect(secondDecoration.color, themeData.primaryColorDark);
  });

  testWidgets('8 - Should call LoadSurveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });
}