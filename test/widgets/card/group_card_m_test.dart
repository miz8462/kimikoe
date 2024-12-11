import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/card/group_card_m.dart';

void main() {
  group('GroupCardMウィジェット', () {
    final testGroup = IdolGroup(
      name: 'Test Group',
      imageUrl: 'https://example.com/test.jpg',
    );
    final testImagePath = 'assets/images/test.jpg';

    testWidgets('GroupCardMのルーティングテスト', (WidgetTester tester) async {
// 画像のプリキャッシュ
      await tester.runAsync(() async {
        await precacheImage(
          AssetImage(testImagePath),
          tester.element(find.byType(Container)),
        );
      });

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: GroupCardM(
                group: testGroup,
                imageProvider: AssetImage(testImagePath),
              ),
            ),
          ),
          GoRoute(
            path: RoutingPath.groupDetail,
            name: RoutingPath.groupDetail,
            builder: (context, state) {
              final extra = testGroup;
              return Scaffold(
                body: Text('${extra.name}へナビゲーション'),
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // タップ後画面遷移の確認
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsOneWidget);
      expect(find.text('Test Groupへナビゲーション'), findsOneWidget);
    });
  });
}
