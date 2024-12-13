import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/services/supabase_service.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late final SupabaseClient mockSupabase;
  late final MockSupabaseHttpClient mockHttpClient;

  setUpAll(() {
    mockHttpClient = MockSupabaseHttpClient();
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
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

  // NOTE: 現状、データ登録系のテストの後にフェッチのテストを行っているので、データ登録系テストに依存している。
  // NOTE: まとめてテストをすることを前提に変更はしない。
  group('SupabaseService', () {
    testWidgets('insertArtistData', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      await insertArtistData(
        name: 'test artist',
        context: mockContext,
        supabaseClient: mockSupabase,
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
        supabaseClient: mockSupabase,
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

    testWidgets('insertIdolGroupData', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      await insertIdolGroupData(
        name: 'test group',
        context: mockContext,
        supabaseClient: mockSupabase,
        imageUrl: 'https://example.com/image.jpg',
        year: '2023',
        officialUrl: 'https://example.com/official',
        twitterUrl: 'https://twitter.com/test_group',
        instagramUrl: 'https://instagram.com/test_group',
        scheduleUrl: 'https://example.com/schedule',
        comment: 'test comment',
      );
      await tester.pump(Duration(milliseconds: 500));

      final idolGroups = await mockSupabase.from(TableName.idolGroups).select();

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
        supabaseClient: mockSupabase,
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

    testWidgets('insertIdolData', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      await insertIdolData(
        name: 'test idol',
        context: mockContext,
        supabaseClient: mockSupabase,
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

      final idol = await mockSupabase.from(TableName.idol).select();

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
        supabaseClient: mockSupabase,
      );
      await tester.pump(Duration(milliseconds: 500));

      final idol2 = await mockSupabase.from(TableName.idol).select();

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

    testWidgets('insertSongData', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      await insertSongData(
        title: 'test title',
        lyric: 'test lyric',
        context: mockContext,
        supabaseClient: mockSupabase,
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
        supabaseClient: mockSupabase,
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

    // TODO: Supabase CLIでのローカル環境でテストができるらしいよ
    testWidgets('uploadImageToStorage', (WidgetTester tester) async {});
    testWidgets('fetchArtists', (WidgetTester tester) async {
      final artistList = await fetchArtists(
        mockSupabase,
      );

      expect(artistList.length, 2);
      expect(artistList.first[ColumnName.name], 'test artist');
    });

    testWidgets('fetchGroupMembers', (WidgetTester tester) async {
      // NOTE: insertIdolDaltaのテストデータを使っている。
      final members = await fetchGroupMembers(
        1,
        mockSupabase,
      );

      expect(members.length, 1);
      expect(members.first[ColumnName.name], 'test idol');
    });
    testWidgets('fetchIdAndNameList', (WidgetTester tester) async {
      final idolGroupsIdAndNameList = await fetchIdAndNameList(
        TableName.idolGroups,
        mockSupabase,
      );

      expect(idolGroupsIdAndNameList.length, 2);
      expect(idolGroupsIdAndNameList.first[ColumnName.name], 'test group');
    });

    group('fetchSelectedDataIdFromName', () {
      final mockDataList = <Map<String, dynamic>>[
        {
          'id': 1,
          'name': 'test idol',
        },
        {
          'id': 2,
          'name': 'test idol2',
        },
      ];
      test('正常にデータIDを取得できる', () {
        final idolId =
            fetchSelectedDataIdFromName(list: mockDataList, name: 'test idol');
        expect(idolId, 1);
      });
      test('指定された名前がない場合、例外をスローする', () {
        expect(
          () => fetchSelectedDataIdFromName(
            list: mockDataList,
            name: 'test idol3',
          ),
          throwsStateError,
        );
      });
    });

    testWidgets('updateIdolGroup', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.idolGroups).insert({
        ColumnName.id: 1,
        ColumnName.name: 'test group',
        ColumnName.comment: 'test comment',
      });

      await updateIdolGroup(
        id: '1',
        name: 'updated group',
        context: mockContext,
        supabaseClient: mockSupabase,
        imageUrl: 'https://example.com/updated.jpg',
        year: '2024',
        officialUrl: 'https://example.com/updated',
        twitterUrl: 'https://twitter.com/updated',
        instagramUrl: 'https://instagram.com/updated',
        scheduleUrl: 'https://example.com/updated/schedule',
        comment: 'updated comment',
      );

      final updatedGroup = await mockSupabase
          .from(TableName.idolGroups)
          .select()
          .eq(ColumnName.id, 1)
          .single();

      expect(
        updatedGroup[ColumnName.name],
        'updated group',
      );
      expect(
        updatedGroup[ColumnName.comment],
        'updated comment',
      );
      expect(
        updatedGroup[ColumnName.imageUrl],
        'https://example.com/updated.jpg',
      );
      expect(
        updatedGroup[ColumnName.yearFormingGroups],
        2024,
      );
      expect(
        updatedGroup[ColumnName.officialUrl],
        'https://example.com/updated',
      );
      expect(
        updatedGroup[ColumnName.twitterUrl],
        'https://twitter.com/updated',
      );
      expect(
        updatedGroup[ColumnName.instagramUrl],
        'https://instagram.com/updated',
      );
      expect(
        updatedGroup[ColumnName.scheduleUrl],
        'https://example.com/updated/schedule',
      );
    });
    testWidgets('updateSong', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.songs).insert({
        ColumnName.id: 1,
        ColumnName.title: 'test song',
        ColumnName.lyrics: 'test lyrics',
      });

      await updateSong(
        id: 1,
        title: 'updated title',
        lyric: 'updated lyrics',
        context: mockContext,
        supabaseClient: mockSupabase,
        groupId: 1,
        imageUrl: 'https://example.com/updated.jpg',
        releaseDate: '2024-01-22',
        lyricistId: 13,
        composerId: 13,
        comment: 'updated comment',
      );

      final updatedsong = await mockSupabase
          .from(TableName.songs)
          .select()
          .eq(ColumnName.id, 1)
          .single();

      expect(
        updatedsong[ColumnName.title],
        'updated title',
      );
      expect(
        updatedsong[ColumnName.lyrics],
        'updated lyrics',
      );
      expect(
        updatedsong[ColumnName.groupId],
        1,
      );
      expect(
        updatedsong[ColumnName.imageUrl],
        'https://example.com/updated.jpg',
      );
      expect(
        updatedsong[ColumnName.releaseDate],
        '2024-01-22',
      );
      expect(
        updatedsong[ColumnName.lyricistId],
        13,
      );
      expect(
        updatedsong[ColumnName.composerId],
        13,
      );
      expect(
        updatedsong[ColumnName.comment],
        'updated comment',
      );
    });
  });
}