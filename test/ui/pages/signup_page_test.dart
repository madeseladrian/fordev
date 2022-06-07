import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SignUpPresenterSpy presenter;
  
  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    await tester.pumpWidget(
      makePage(path: '/signup', page: () => SignUpPage(presenter: presenter))
    );
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('1,2,3,4,5 - Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

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
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));
  });
  
  testWidgets('7 - Should call validate with correct email', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));
  });

  testWidgets('8 - Should call validate with correct password', (WidgetTester tester) async {
    await loadPage(tester);

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets('9 - Should call validate with correct passwordConfirmation', (WidgetTester tester) async {
    await loadPage(tester);

    final passwordConfirmation = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), passwordConfirmation);
    verify(() => presenter.validatePasswordConfirmation(passwordConfirmation));
  });

  testWidgets('10 - Should present error if name is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNameError(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets('11 - Should present error if name is empty', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNameError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('12 - Should present no error if name is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNameValid();
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('13 - Should present error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets('14 - Should present error if email is empty', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('15 - Should present no error if email is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailValid();
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('16 - Should present error if password is empty', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('17 - Should present no error if password is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordValid();
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('18 - Should present error if passwordConfirmation is empty', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordConfirmationError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('19 - Should present no error if passwordConfirmation is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordConfirmationValid();
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Confirmar senha'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('20 - Should enable button if form is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('21 - Should disable button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormError();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });
  
  testWidgets('22 - Should call add account on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signUp()).called(1);
  });

  testWidgets('23 - Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('24 - Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    presenter.emitLoading(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('25 - Should present error message if add account fails', (WidgetTester tester) async {
    await loadPage(tester);

    await tester.showKeyboard(find.byKey(const Key('passwordConfirmation-input-signup')));
    await tester.pump();
    final gestureDetector = find.byKey(const Key('keyboard-dismiss-signup'));
    await tester.tap(gestureDetector);
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    presenter.emitMainError(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });

  testWidgets('26 - Should present error message if add account throws', (WidgetTester tester) async {
    await loadPage(tester);

    await tester.showKeyboard(find.byKey(const Key('passwordConfirmation-input-signup')));
    await tester.pump();
    final gestureDetector = find.byKey(const Key('keyboard-dismiss-signup'));
    await tester.tap(gestureDetector);
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    presenter.emitMainError(UIError.emailInUse);
    await tester.pump();

    expect(find.text('O email já está em uso.'), findsOneWidget);
  });
  
  testWidgets('27 - Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, 'any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('28 - Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pumpAndSettle();
    expect(currentRoute, '/signup');

    presenter.emitNavigateTo('');
    await tester.pumpAndSettle();
    expect(currentRoute, '/signup');
  });

  testWidgets('29 - Should call goToLogin on link click', (WidgetTester tester) async {
    await loadPage(tester);

    await tester.pump();
    final button = find.text('Login');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToLogin()).called(1);
  });
}