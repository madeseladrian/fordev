import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenterSpy presenter;

  Future<void> _testPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    
    when(() => presenter.loadData()).thenAnswer((_) async => _);

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter)),
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  testWidgets('Should call LoadSurveys on page load', (WidgetTester tester) async {
    await _testPage(tester);

    verify(() => presenter.loadData()).called(1);
  });
}