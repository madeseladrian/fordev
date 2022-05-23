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

  testWidgets('6 - Should call validate with correct name', (WidgetTester tester) async {
    await _testPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));
  });
  
  testWidgets('7 - Should call validate with correct email', (WidgetTester tester) async {
    await _testPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));
  });

  testWidgets('8 - Should call validate with correct password', (WidgetTester tester) async {
    await _testPage(tester);

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets('9 - Should call validate with correct passwordConfirmation', (WidgetTester tester) async {
    await _testPage(tester);

    final passwordConfirmation = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), passwordConfirmation);
    verify(() => presenter.validatePasswordConfirmation(passwordConfirmation));
  });
}