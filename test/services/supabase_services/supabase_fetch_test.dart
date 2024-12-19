import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test_utils/mocks/logger_mock.dart';

void main() {
  late final SupabaseClient errorSupabase;
  late final SupabaseClient mockSupabase;
  late final MockSupabaseHttpClient mockHttpClient;
  late final MockLogger mockLogger;

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
    mockLogger = MockLogger();
  });

  tearDown(() async {
    mockHttpClient.reset();
  });

  group('fetchArtists', () {
    testWidgets('fetchArtistsの正常動作', (WidgetTester tester) async {
      await mockSupabase.from(TableName.artists).insert({
        ColumnName.name: 'test artist',
      });
      final artistList = await fetchArtists(
        supabase: mockSupabase,
        logger: mockLogger,
      );

      expect(artistList.length, 1);
      expect(artistList.first[ColumnName.name], 'test artist');
    });
    testWidgets('fetchArtistsの例外処理', (WidgetTester tester) async {
      var didThrowError = false;

      try {
        await fetchArtists(
          supabase: errorSupabase,
          logger: mockLogger,
        );
        verify(mockLogger.e('アーティストのリストの取得中にエラーが発生しました')).called(1);
      } catch (e) {
        didThrowError = true;
      }
      expect(didThrowError, isTrue);
    });
  });

  group('fetchGroupMembers', () {
    testWidgets('fetchGroupMembers', (WidgetTester tester) async {
      await mockSupabase.from(TableName.idols).insert({
        ColumnName.groupId: 1,
        ColumnName.name: 'test idol',
      });
      final members = await fetchGroupMembers(
        1,
        supabase: mockSupabase,
        logger: mockLogger,
      );

      expect(members.length, 1);
      expect(members.first[ColumnName.name], 'test idol');
    });

    testWidgets('fetchGroupMembersの例外処理', (WidgetTester tester) async {
      final mockLogger = MockLogger();
      var didThrowError = false;

      try {
        await fetchGroupMembers(
          1,
          supabase: errorSupabase,
          logger: mockLogger,
        );

        verify(mockLogger.e('グループメンバーリストの取得中にエラーが発生しました')).called(1);
      } catch (e) {
        didThrowError = true;
      }
      expect(didThrowError, isTrue);
    });
  });

  group('fetchIdAndNameList', () {
    testWidgets('fetchIdAndNameList', (WidgetTester tester) async {
      await mockSupabase.from(TableName.idolGroups).insert({
        ColumnName.name: 'test group',
      });
      final idolGroupsIdAndNameList = await fetchIdAndNameList(
        TableName.idolGroups,
        supabase: mockSupabase,
        logger: mockLogger,
      );

      expect(idolGroupsIdAndNameList.length, 1);
      expect(idolGroupsIdAndNameList.first[ColumnName.name], 'test group');
    });
    testWidgets('fetchIdAndNameList', (WidgetTester tester) async {
      var didThrowError = false;

      try {
        await fetchIdAndNameList(
          TableName.idolGroups,
          supabase: errorSupabase,
          logger: mockLogger,
        );
        verify(mockLogger.e('アイドルグループのIDと名前のリストの取得中にエラーが発生しました')).called(1);
      } catch (e) {
        didThrowError = true;
      }

      expect(didThrowError, isTrue);
    });
  });

  // HACK: Supabase CLI でできるらしいよ
  group('fetchImageUrl', () {
    testWidgets('fetchImageUrlの正常動作', (WidgetTester tester) async {});
    testWidgets('fetchImageUrlの例外処理', (WidgetTester tester) async {
      var didThrowError = false;

      try {
        fetchImageUrl(
          TableName.idolGroups,
          supabase: errorSupabase,
          logger: mockLogger,
        );
        verify(mockLogger.e('画像URLの取得中にエラーが発生しました')).called(1);
      } catch (e) {
        didThrowError = true;
      }

      expect(didThrowError, isTrue);
    });
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
}
