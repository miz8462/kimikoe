import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('アプリの起動', (WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();

    expect(find.byType(KimikoeApp),findsOneWidget);
  });
}
