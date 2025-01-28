import 'package:flutter_test/flutter_test.dart';

import '../robots/auth_robot.dart';

Future<void> login(WidgetTester tester) async {
  final email = 'doskoi@doskoi.com';
  final password = 'doskoidoskoi';

  final robot = AuthRobot(tester);

  await tester.pumpAndSettle();

  await robot.enterEmail(email);
  await robot.enterPassword(password);
  await tester.pumpAndSettle();
  await robot.tapLoginOrSignUpButton();
  await tester.pumpAndSettle();
}
