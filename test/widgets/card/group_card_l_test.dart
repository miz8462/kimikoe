import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/card/group_card_l.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GroupCardLウィジェット', () {
    final testGroup = IdolGroup(
      name: 'Test Group',
      imageUrl: 'https://example.com/test.jpg',
    );
    final testImagePath = 'assets/images/Kimikoe_app_icon.png';

    testWidgets('GroupCardL、ナビゲーションテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Container()),
        ),
      ); // 画像のプリキャッシュ
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
              body: GroupCardL(
                group: testGroup,
                imageProvider: AssetImage(testImagePath),
              ),
            ),
          ),
          GoRoute(
            path: '${RoutingPath.groupList}/${RoutingPath.songList}',
            builder: (context, state) {
              final extra = state.extra! as IdolGroup;
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

      // // 画像をプリロード
      // await tester.runAsync(() async {
      //   await precacheImage(
      //     AssetImage(testImagePath),
      //   );
      // });

      // タップ後画面遷移の確認
      await tester.tap(find.byType(GroupCardL));
      await tester.pumpAndSettle();
      expect(find.text('Test Groupへナビゲーション'), findsOneWidget);
    });
  });
}
