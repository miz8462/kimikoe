import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/card/song_card.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  group('SongCardウィジェット', () {
    final testSong = Song(
      title: 'test title',
      lyrics: '[{"lyric": "test lyrics"}]',
      imageUrl: 'https://example.com/image.jpg',
    );
    final testGroup = IdolGroup(
      name: 'test group',
      imageUrl: 'https://example.com/image.jpg',
    );
    final testImagePath = 'assets/images/test.jpg';

    testWidgets('SongCardのルーティングテスト', (WidgetTester tester) async {
      // 画像のプリキャッシュ
      await tester.runAsync(() async {
        await precacheImage(
          AssetImage(testImagePath),
          tester.element(find.byType(Container)),
        );
      });

      final router = GoRouter(
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: SongCard(
                song: testSong,
                group: testGroup,
                imageProvider: AssetImage(testImagePath),
              ),
            ),
          ),
          GoRoute(
            path: RoutingPath.lyric,
            name: RoutingPath.lyric,
            builder: (context, state) {
              final extra = state.extra! as Map<String, dynamic>;
              final song = extra['song'] as Song;
              final group = extra['group'] as IdolGroup;
              return Scaffold(
                body: Column(
                  children: [
                    Text(song.title),
                    Text(group.name),
                  ],
                ),
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      // タップして画面遷移
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // 画面遷移後のテキスト確認
      expect(find.text('test title'), findsOneWidget);
      expect(find.text('test group'), findsOneWidget);
    });
    testWidgets('SongCardの表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: SongCard(
            song: testSong,
            group: testGroup,
            imageProvider: AssetImage(testImagePath),
          ),
        ),
      );

      expect(find.text('test title'), findsOneWidget);
      expect(find.text('test lyrics'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}
