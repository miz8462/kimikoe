import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_insert.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test_utils/mocks/logger_mock.dart';

void main() {
  logger = MockLogger();
  late final SupabaseClient errorSupabase;
  late final SupabaseClient mockSupabase;
  late final MockSupabaseHttpClient mockHttpClient;

  setUpAll(() async {
    mockHttpClient = MockSupabaseHttpClient();
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
    );

    errorSupabase = SupabaseClient(
      'error',
      'error',
    );
  });

  tearDown(() async {
    mockHttpClient.reset();
  });
  Future<BuildContext> createMockContext(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Container();
            },
          ),
        ),
      ),
    );
    return tester.element(find.byType(Container));
  }

  group('SupabaseService', () {
    group('insertArtistData', () {
      testWidgets('insertArtistDataの正常動作', (WidgetTester tester) async {
        final mockContext = await createMockContext(tester);

        await insertArtistData(
          name: 'test artist',
          context: mockContext,
          supabase: mockSupabase,
          imageUrl: 'https://example.com/image.jpg',
          comment: 'test comment',
        );
        await tester.pump(Duration(milliseconds: 500));

        final artists = await mockSupabase.from(TableName.artists).select();

        expect(artists.length, 1);
        expect(artists.first, {
          'name': 'test artist',
          'image_url': 'https://example.com/image.jpg',
          'comment': 'test comment',
        });
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('アーティストを登録しました: test artist'), findsOneWidget);

        // name以外がnullの場合
        await insertArtistData(
          name: 'test artist2',
          context: mockContext,
          supabase: mockSupabase,
        );
        await tester.pump(Duration(milliseconds: 500));

        final artists2 = await mockSupabase.from('artists').select();

        expect(artists2.length, 2);
        expect(artists2.last, {
          'name': 'test artist2',
          'image_url': null,
          'comment': null,
        });
      });
      testWidgets('insertArtistDataの例外処理', (WidgetTester tester) async {
        final mockContext = await createMockContext(tester);
        var didThrowError = false;
        try {
          await insertArtistData(
            name: 'test artist',
            context: mockContext,
            supabase: errorSupabase,
            imageUrl: 'https://example.com/image.jpg',
            comment: 'test comment',
          );
          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.text('アーティアーティストの登録中にエラーが発生しました: test artist'),
            findsOneWidget,
          );
        } catch (e) {
          didThrowError = true;
        }

        expect(didThrowError, isTrue);
      });
    });
    group('insertIdolGroupData', () {
      testWidgets('insertIdolGroupDataの正常動作', (WidgetTester tester) async {
        final mockContext = await createMockContext(tester);

        await insertIdolGroupData(
          name: 'test group',
          context: mockContext,
          supabase: mockSupabase,
          imageUrl: 'https://example.com/image.jpg',
          year: '2023',
          officialUrl: 'https://example.com/official',
          twitterUrl: 'https://twitter.com/test_group',
          instagramUrl: 'https://instagram.com/test_group',
          scheduleUrl: 'https://example.com/schedule',
          comment: 'test comment',
        );
        await tester.pump(Duration(milliseconds: 500));

        final idolGroups =
            await mockSupabase.from(TableName.idolGroups).select();

        expect(idolGroups.length, 1);
        expect(idolGroups.first, {
          'name': 'test group',
          'image_url': 'https://example.com/image.jpg',
          'year_forming_group': 2023,
          'official_url': 'https://example.com/official',
          'twitter_url': 'https://twitter.com/test_group',
          'instagram_url': 'https://instagram.com/test_group',
          'schedule_url': 'https://example.com/schedule',
          'comment': 'test comment',
        });
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('グループを登録しました: test group'), findsOneWidget);

        // name以外がnullの場合
        await insertIdolGroupData(
          name: 'test group2',
          context: mockContext,
          supabase: mockSupabase,
        );
        await tester.pump(Duration(milliseconds: 500));

        final groups2 = await mockSupabase.from(TableName.idolGroups).select();

        expect(groups2.length, 2);
        expect(groups2.last, {
          'name': 'test group2',
          'image_url': null,
          'year_forming_group': null,
          'official_url': null,
          'twitter_url': null,
          'instagram_url': null,
          'schedule_url': null,
          'comment': null,
        });
      });

      testWidgets('insertIdolGroupDataの例外処理', (WidgetTester tester) async {
        final mockContext = await createMockContext(tester);
        var didThrowError = false;
        try {
          await insertIdolGroupData(
            name: 'test group',
            context: mockContext,
            supabase: errorSupabase,
            imageUrl: 'https://example.com/image.jpg',
            comment: 'test comment',
          );
          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.text('グループの登録中にエラーが発生しました: test group'),
            findsOneWidget,
          );
        } catch (e) {
          didThrowError = true;
        }

        expect(didThrowError, isTrue);
      });
    });

    group('insertIdolData', () {
      testWidgets('insertIdolDataの正常動作', (WidgetTester tester) async {
        final mockContext = await createMockContext(tester);

        await insertIdolData(
          name: 'test idol',
          context: mockContext,
          supabase: mockSupabase,
          groupId: 1,
          color: 'test color',
          imageUrl: 'https://example.com/image.jpg',
          birthday: '01-22',
          birthYear: 2002,
          height: 158,
          hometown: 'Sapporo',
          debutYear: 2023,
          comment: 'test comment',
        );
        await tester.pump(Duration(milliseconds: 500));

        final idol = await mockSupabase.from(TableName.idols).select();

        expect(idol.length, 1);
        expect(idol.first, {
          'name': 'test idol',
          'group_id': 1,
          'color': 'test color',
          'image_url': 'https://example.com/image.jpg',
          'birthday': '01-22',
          'birth_year': 2002,
          'height': 158,
          'hometown': 'Sapporo',
          'debut_year': 2023,
          'comment': 'test comment',
        });
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('アイドルを登録しました: test idol'), findsOneWidget);

        // name以外がnullの場合
        await insertIdolData(
          name: 'test idol2',
          context: mockContext,
          supabase: mockSupabase,
        );
        await tester.pump(Duration(milliseconds: 500));

        final idol2 = await mockSupabase.from(TableName.idols).select();

        expect(idol2.length, 2);
        expect(idol2.last, {
          'name': 'test idol2',
          'group_id': null,
          'color': null,
          'image_url': null,
          'birthday': null,
          'birth_year': null,
          'height': null,
          'hometown': null,
          'debut_year': null,
          'comment': null,
        });
      });

      testWidgets('insertIdolDataの例外処理', (WidgetTester tester) async {
        final mockContext = await createMockContext(tester);
        var didThrowError = false;
        try {
          await insertIdolData(
            name: 'test idol',
            context: mockContext,
            supabase: errorSupabase,
            imageUrl: 'https://example.com/image.jpg',
            comment: 'test comment',
          );
          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.text('アイドルの登録中にエラーが発生しました: test idol'),
            findsOneWidget,
          );
        } catch (e) {
          didThrowError = true;
        }

        expect(didThrowError, isTrue);
      });
    });

    group('insertSongData', () {
      testWidgets('insertSongDataの正常動作', (WidgetTester tester) async {
        final mockContext = await createMockContext(tester);

        await insertSongData(
          title: 'test title',
          lyric: 'test lyric',
          context: mockContext,
          supabase: mockSupabase,
          groupId: 1,
          imageUrl: 'https://example.com/image.jpg',
          releaseDate: '2023-01-22',
          lyricistId: 1,
          composerId: 1,
          comment: 'test comment',
        );
        await tester.pump(Duration(milliseconds: 500));

        final song = await mockSupabase.from(TableName.songs).select();

        expect(song.length, 1);
        expect(song.first, {
          'title': 'test title',
          'lyrics': 'test lyric',
          'group_id': 1,
          'image_url': 'https://example.com/image.jpg',
          'release_date': '2023-01-22',
          'lyricist_id': 1,
          'composer_id': 1,
          'comment': 'test comment',
        });
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('曲を登録しました: test title'), findsOneWidget);

        // オプションがnullの場合
        await insertSongData(
          title: 'test title2',
          lyric: 'test lyric2',
          context: mockContext,
          supabase: mockSupabase,
        );
        await tester.pump(Duration(milliseconds: 500));

        final song2 = await mockSupabase.from(TableName.songs).select();

        expect(song2.length, 2);
        expect(song2.last, {
          'title': 'test title2',
          'lyrics': 'test lyric2',
          'group_id': null,
          'image_url': null,
          'release_date': null,
          'lyricist_id': null,
          'composer_id': null,
          'comment': null,
        });
      });

      testWidgets('insertSongDataの例外処理', (WidgetTester tester) async {
        final mockContext = await createMockContext(tester);
        var didThrowError = false;
        try {
          await insertSongData(
            title: 'test song',
            lyric: 'test lyric',
            context: mockContext,
            supabase: errorSupabase,
            imageUrl: 'https://example.com/image.jpg',
            comment: 'test comment',
          );
          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.text('曲の登録中にエラーが発生しました: test song'),
            findsOneWidget,
          );
        } catch (e) {
          didThrowError = true;
        }

        expect(didThrowError, isTrue);
      });
    });
  });
}
