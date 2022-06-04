import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenterSpy presenter;
  late StreamController<List<SurveyViewModel>> surveysController;
  late StreamController<String> navigateToController;
  late StreamController<bool> isSessionExpiredController;

  final themeData = makeAppTheme();

  List<SurveyViewModel> makeSurveyList() => const [
    SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
    SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
    SurveyViewModel(id: '3', question: 'Question 3', date: 'Date 3', didAnswer: true)
  ];

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    surveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();
    isSessionExpiredController = StreamController<bool>();

    when(() => presenter.loadData()).thenAnswer((_) async => _);
    when(() => presenter.surveysStream).thenAnswer((_) => surveysController.stream);
    when(() => presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => presenter.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter)),
        GetPage(name: '/any_route', page: () => const Scaffold(body: Text('fake page'))),
        GetPage(name: '/login', page: () => const Scaffold(body: Text('fake login')))
      ],
      theme: themeData,
    );
    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    surveysController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  });

  testWidgets('1 - Should call LoadSurveys on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('2,3 - Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    surveysController.add(makeSurveyList());
    await tester.pump();
    expect(find.text('Question 1'), findsWidgets);
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

  testWidgets('9 - Should call goToSurveyResult on survey click', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveyList());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(() => presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('10 - Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('11 - Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/surveys');
  });

  testWidgets('12 - Should logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('13 - Should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pump();
    expect(Get.currentRoute, '/surveys');
  });
}