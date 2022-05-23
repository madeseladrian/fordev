import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  late SignUpPresenter presenter;

  Future<void> _testPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),  
      ]  
    );
    await tester.pumpWidget(signUpPage);
  }

  testWidgets('1,2,3,4,5 - Should load with correct initial state', (WidgetTester tester) async {
    await _testPage(tester);

    final nameTextChildren = find.descendant(
      of: find.bySemanticsLabel('Nome'),
      matching: find.byType(Text),
    );
    expect(
      nameTextChildren, 
      findsOneWidget,
      reason: 'When a TextFormField has only one text child, means it has no errors, ' 
      'since one of the childs is always the label text'  
    );

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );
    expect(emailTextChildren, findsOneWidget,);

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );
    expect(passwordTextChildren, findsOneWidget);

    final passwordConfirmationTextChildren = find.descendant(
      of: find.bySemanticsLabel('Confirmar senha'),
      matching: find.byType(Text),
    );
    expect(passwordConfirmationTextChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('4 - Should call validate with correct name', (WidgetTester tester) async {
    await _testPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));
  });
}