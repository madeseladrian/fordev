import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    await tester.pumpWidget(makePage(
      path: '/surveys', 
      page: () => SurveysPage(presenter: presenter)
    ));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('1 - Should call LoadSurveys on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('2 - Should call LoadSurveys on reload', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('3,4 - Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    presenter.emitSurveys(ViewModelFactory.makeSurveyList());
    await tester.pump();
    expect(find.text('Question 1'), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('5 - Should present error if surveysStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('6,7 - Should present list if surveysStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyList());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('8 - Should present right colors', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyList());
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

  testWidgets('9 - Should call LoadSurveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('10 - Should call goToSurveyResult on survey click', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyList());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(() => presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('11 - Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('12 - Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentRoute, '/surveys');
  });

  testWidgets('13 - Should logout', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSessionExpired();
    await tester.pumpAndSettle();
    expect(currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('14 - Should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSessionExpired(false);
    await tester.pump();
    expect(currentRoute, '/surveys');
  });
}