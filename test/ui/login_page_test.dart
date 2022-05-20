import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
 
class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController; 
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController; 
  
  Future<void> _testLoginPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();

    when(() => presenter.authenticate()).thenAnswer((_) async => _);
    when(() => presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);

    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter: presenter)),
      ]  
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  });

  testWidgets('1,2,3 - Should load with correct initial state', (WidgetTester tester) async {
    await _testLoginPage(tester);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );
    expect(
      emailTextChildren, 
      findsOneWidget,
      reason: 'When a TextFormField has only one text child, means it has no errors, ' 
      'since one of the childs is always the label text'  
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );
    expect(
      passwordTextChildren, 
      findsOneWidget,  
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  
  testWidgets('4 - Should call validate with correct email', (WidgetTester tester) async {
    await _testLoginPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));
  });

  testWidgets('5 - Should call validate with correct password', (WidgetTester tester) async {
    await _testLoginPage(tester);

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets('6 - Should present error if email is invalid', (WidgetTester tester) async {
    await _testLoginPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  
  testWidgets('7 - Should present error if email is empty', (WidgetTester tester) async {
    await _testLoginPage(tester);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  
  testWidgets('8 - Should present no error if email is valid', (WidgetTester tester) async {
    await _testLoginPage(tester);

    emailErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget
    );
  });
  
  testWidgets('9 - Should present error if password is empty', (WidgetTester tester) async {
    await _testLoginPage(tester);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('10 - Should present no error if password is valid', (WidgetTester tester) async {
    await _testLoginPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget
    );
  });
  
  testWidgets('11 - Should enable button if form is valid', (WidgetTester tester) async {
    await _testLoginPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('12 - Should disable button if form is invalid', (WidgetTester tester) async {
    await _testLoginPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('13 - Should call authentication on form submit', (WidgetTester tester) async {
    await _testLoginPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.authenticate()).called(1);
  });

  testWidgets('14 - Should present loading', (WidgetTester tester) async {
    await _testLoginPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('15 - Should hide loading', (WidgetTester tester) async {
    await _testLoginPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}