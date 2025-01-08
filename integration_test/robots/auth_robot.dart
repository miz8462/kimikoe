import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:robot/robot.dart';

import '../integration_test_utils/pump_until_found.dart';

class AuthRobot extends Robot<SignInScreen> {
  AuthRobot(super.tester);

  late String email;
  late String password;
  late String name;

  Future<void> show() async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: SignInScreen(),
        ),
      ),
    );
  }

  Future<void> enterEmail(String email) async {
    final emailFieldFinder = find.byKey(Key('emailField'));
    await tester.enterText(emailFieldFinder, email);
    await tester.pumpAndSettle();
  }

  Future<void> enterPassword(String password) async {
    final passwordFieldFinder = find.byKey(Key('passwordField'));
    await tester.enterText(passwordFieldFinder, password);
    await tester.pumpAndSettle();
  }

  Future<void> enterName(String name) async {
    final nameFieldFinder = find.byKey(Key('nameField'));
    await tester.enterText(nameFieldFinder, name);
    await tester.pumpAndSettle();
  }

  Future<void> tapToggleAuthButton() async {
    final signUpTextFinder = find.text('新規登録する');
    await tester.tap(signUpTextFinder);
    await tester.pumpAndSettle();
    final logInTextFinder = find.text('アカウントを持っている');
    await tester.tap(logInTextFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapSignUpButton() async {
    final loginButtonFinder = find.text('サインアップ');
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginButton() async {
    final loginButtonFinder = find.text('ログイン');
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapGoogleLoginButton() async {}

  Future<void> expectHomeScreen() async {
    await tester.pumpUntilFound(find.byType(IdolGroupListScreen));
    expect(find.byType(IdolGroupListScreen), findsOneWidget);
  }
}
