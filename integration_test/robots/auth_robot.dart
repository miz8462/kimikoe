import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:robot/robot.dart';

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
    final signUpTextFinder = find.byKey(Key('switchButton'));
    await tester.tap(signUpTextFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginOrSignUpButton() async {
    final loginButtonFinder = find.byKey(Key('loginButton'));
    expect(loginButtonFinder, findsOneWidget);

    await tester.scrollUntilVisible(
      loginButtonFinder,
      200,
      scrollable: find
          .ancestor(of: loginButtonFinder, matching: find.byType(Scrollable))
          .first, // 特定のScrollableを指定
    );
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapGoogleLoginButton() async {}

  Future<void> expectHomeScreen() async {
    expect(find.byType(IdolGroupListScreen), findsOneWidget);
  }
}
