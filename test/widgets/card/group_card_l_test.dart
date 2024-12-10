import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/card/group_card_l.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  group('GroupCardLウィジェット', () {
    final testGroup = IdolGroup(
      name: 'Test Group',
      imageUrl: 'https://example.com/test.jpg',
    );
    final testImagePath = 'assets/images/test.jpg';

    testWidgets('GroupCardLのナビゲーションテスト', (WidgetTester tester) async {
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

      // タップ後画面遷移の確認
      await tester.tap(find.byType(GroupCardL));
      await tester.pumpAndSettle();
      expect(find.text('Test Groupへナビゲーション'), findsOneWidget);
    });
    testWidgets('GroupCardLの表示テスト', (WidgetTester tester) async {
      // 画像のプリキャッシュ
      await tester.runAsync(() async {
        await precacheImage(
          AssetImage(testImagePath),
          tester.element(find.byType(Container)),
        );
      });
      await tester.pumpWidget(
        buildTestWidget(
          child: GroupCardL(
            group: testGroup,
            imageProvider: AssetImage(testImagePath),
          ),
        ),
      );

      // 表示確認
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Test Group'), findsOneWidget);
    });
  });
}
