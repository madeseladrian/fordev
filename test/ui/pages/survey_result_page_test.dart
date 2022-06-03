import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  late SurveyResultPresenterSpy presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<SurveyResultViewModel?> surveyResultController;

  SurveyResultViewModel makeSurveyResult() => const SurveyResultViewModel(
    surveyId: 'Any id',
    question: 'Question',
    answers: [
      SurveyAnswerViewModel(
        image: 'Image 0',
        answer: 'Answer 0',
        isCurrentAnswer: true,
        percent: '60%'
      ),
      SurveyAnswerViewModel(
        answer: 'Answer 1',
        isCurrentAnswer: false,
        percent: '40%'
      )
    ]
  );

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    isLoadingController = StreamController<bool>();
    surveyResultController = StreamController<SurveyResultViewModel?>();

    when(() => presenter.loadData()).thenAnswer((_) async => _);
    when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream); 
    when(() => presenter.surveyResultStream).thenAnswer((_) => surveyResultController.stream);

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

  testWidgets('4 - Should present error if surveyResultStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
  });

  testWidgets('5 - Should call LoadSurveyResult on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('6,7,8,9,10,11,12,13 - Should present valid data if surveyResultStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisabledIcon), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });
}