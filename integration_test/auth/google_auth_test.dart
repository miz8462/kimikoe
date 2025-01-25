import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/providers/supabase_provider.dart';

import '../robots/auth_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ログイン', (WidgetTester tester) async {
    await app.main();

    if (supabase.auth.currentSession != null) {
      await supabase.auth.signOut();
    }

    await tester.pumpAndSettle();

    final robot = AuthRobot(tester);
    
    await robot.expectHomeScreen();
  });
}
