import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  late SignUpPresenter presenter;
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<String?> navigateToController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  Future<void> _testPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    nameErrorController = StreamController<UIError?>();
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    passwordConfirmationErrorController = StreamController<UIError?>();
    mainErrorController = StreamController<UIError?>();
    navigateToController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();

    when(() => presenter.signUp()).thenAnswer((_) async => _);
    when(() => presenter.nameErrorStream).thenAnswer((_) => nameErrorController.stream);
    when(() => presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.passwordConfirmationErrorStream).thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(() => presenter.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(() => presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
        GetPage(name: '/any_route', page: () => const Scaffold(body: Text('fake page')))  
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

  testWidgets('10 - Should present error if name is invalid', (WidgetTester tester) async {
    await _testPage(tester);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets('11 - Should present error if name is empty', (WidgetTester tester) async {
    await _testPage(tester);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('12 - Should present no error if name is valid', (WidgetTester tester) async {
    await _testPage(tester);

    nameErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('13 - Should present error if email is invalid', (WidgetTester tester) async {
    await _testPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets('14 - Should present error if email is empty', (WidgetTester tester) async {
    await _testPage(tester);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('15 - Should present no error if email is valid', (WidgetTester tester) async {
    await _testPage(tester);

    emailErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('16 - Should present error if password is empty', (WidgetTester tester) async {
    await _testPage(tester);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('17 - Should present no error if password is valid', (WidgetTester tester) async {
    await _testPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('18 - Should present error if passwordConfirmation is empty', (WidgetTester tester) async {
    await _testPage(tester);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('19 - Should present no error if passwordConfirmation is valid', (WidgetTester tester) async {
    await _testPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Confirmar senha'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('20 - Should enable button if form is valid', (WidgetTester tester) async {
    await _testPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('21 - Should disable button if form is invalid', (WidgetTester tester) async {
    await _testPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });
  
  testWidgets('22 - Should call add account on form submit', (WidgetTester tester) async {
    await _testPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signUp()).called(1);
  });

  testWidgets('23 - Should present loading', (WidgetTester tester) async {
    await _testPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('24 - Should hide loading', (WidgetTester tester) async {
    await _testPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('25 - Should present error message if add account fails', (WidgetTester tester) async {
    await _testPage(tester);

    mainErrorController.add(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });

  testWidgets('26 - Should present error message if add account throws', (WidgetTester tester) async {
    await _testPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
  });
  
  testWidgets('27 - Should change page', (WidgetTester tester) async {
    await _testPage(tester);

    navigateToController.add('any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, 'any_route');
    expect(find.text('fake page'), findsOneWidget);
  });
}