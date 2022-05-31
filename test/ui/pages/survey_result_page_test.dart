import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:fordev/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  late SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    when(() => presenter.loadData()).thenAnswer((_) async => _);

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

  testWidgets('1 - Should call LoadSurveyResult on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });
}