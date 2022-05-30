import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:fordev/ui/pages/pages.dart';

ThemeData themeData() {
  const primaryColor = Color.fromRGBO(136, 14, 79, 1);
  const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  const secondaryColor = Color.fromRGBO(0, 77, 64, 1);
  const secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);
  
  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    highlightColor: secondaryColor,
    secondaryHeaderColor: secondaryColorDark,
    colorScheme: const ColorScheme.light(primary: primaryColor),
    backgroundColor: Colors.white,
  );
}

class TestWidget extends StatelessWidget {
  const TestWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('test_column'),
      children: [
        Container(
          key: const Key('1'),
          decoration: BoxDecoration(color: themeData().primaryColor),
          child: const Text('1'),
        ),
        Container(
          key: const Key('2'),
          decoration: const BoxDecoration(color: Colors.white),
          child: const Text('2'),
        ),
        Container(
          key: const Key('3'),
          decoration: const BoxDecoration(color: Colors.blue),
          child: const Text('3'),
        ),
        Column(
          children: [
            Container(
              key: const Key('4'),
              decoration: const BoxDecoration(color: Colors.red),
              child: const Text('4'),
            ),
            Container(
              key: const Key('5'),
              decoration: const BoxDecoration(color: Colors.white),
              child: const Text('5'),
            ),
            Container(
              key: const Key('6'),
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Text('6'),
            ),
          ],
        )
      ],
    );
  }
}

class SurveyItemTest extends StatelessWidget {
  final SurveyViewModel viewModel;

  const SurveyItemTest({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('survey_item_${viewModel.id}'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: viewModel.didAnswer ? Colors.green : Colors.red,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 0,
            blurRadius: 2,
            color: Colors.black
          )
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.date,
            style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),
          Text(
            viewModel.question,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }
}

List<SurveyViewModel> makeSurveyList() => const [
    SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
    SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
    SurveyViewModel(id: '3', question: 'Question 3', date: 'Date 3', didAnswer: true),
  ];

class CarrouselWidgetTest extends StatelessWidget {
  const CarrouselWidgetTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1
          ),
          items: makeSurveyList().map(
            (viewModel) {
              return SurveyItemTest(viewModel: viewModel);
          }).toList(),
        );
      }
    );
  }
}

Widget makeTestable(Widget widget) => MaterialApp(home: widget);

void main() {
  testWidgets('TestWidget with Column', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(const TestWidget()));
    
    final columnFinder = find.byKey(const Key('test_column'));
    expect(columnFinder, findsOneWidget);
  });

  testWidgets('TestWidget with Color', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(const TestWidget()));

    final firstContainer = tester.widget<Container>(find.byKey(const Key('1')));
    final decoration = firstContainer.decoration as BoxDecoration;
    expect(decoration.color, themeData().primaryColor);
  });

  testWidgets('TestWidget with Text', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(const TestWidget()));

    final firstContainer = tester.widget<Container>(find.byKey(const Key('1')));
    final text = firstContainer.child as Text;
    expect(text.data, '1');
  });

  testWidgets('TestWidget with Color inside Column', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(const TestWidget()));

    final firstContainer = tester.widget<Container>(find.byKey(const Key('5')));
    final decoration = firstContainer.decoration as BoxDecoration;
    final color = decoration.color;
    expect(color, Colors.white);
  });

  testWidgets('TestWidget with Color inside a Carrousel', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(const CarrouselWidgetTest()));

    final container = tester.widget<Container>(find.byKey(const Key('survey_item_2')));
    final decoration = container.decoration as BoxDecoration;
    final color = decoration.color as Color;
    expect(color, Colors.red);
  });
}