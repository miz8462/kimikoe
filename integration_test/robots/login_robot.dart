import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  const AuthRobot(this.tester);

  final WidgetTester tester;

  Future<void> enterEmail(String email) async {}

  Future<void> enterPassword(String password) async {}

  Future<void> enterName(String name) async {}

  Future<void> tapToggleAuthButton() async {}

  Future<void> tJapSignUpButton() async {}

  Future<void> tapLoginButton() async {}

  Future<void> tapGoogleLoginButton() async {}
}
