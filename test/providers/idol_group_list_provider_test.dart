import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/groups_providere.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test_utils/mocks/logger_mock.dart';

void main() {
  late GroupsNotifier notifier;
  late SupabaseClient mockSupabase;
  late SupabaseClient errorSupabase;
  late MockLogger mockLogger;

  setUp(() async {
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
    );
    errorSupabase = SupabaseClient('error', 'error');
    await mockSupabase.from(TableName.idolGroups).insert({
      ColumnName.id: 1,
      ColumnName.name: 'test group',
      ColumnName.imageUrl: 'https://example.com/test.jpg',
    });
    mockLogger = MockLogger();

    notifier = GroupsNotifier();
    await notifier.initialize(
      supabase: mockSupabase,
      logger: mockLogger,
    );
  });

  tearDown(() {
    notifier.dispose();
  });

  group('IdolGroupListState', () {
    test('クラスの初期化', () {
      final state = GroupsState();

      expect(state, isA<GroupsState>());
      expect(state.groups, isA<List<IdolGroup>>());
      expect(state.isLoading, isFalse);
    });

    test('クラスをcopyWithで上書き', () {
      final state = GroupsState();
      final newGroups = [
        IdolGroup(
          name: 'test group',
          imageUrl: 'https://example.com/test.jpg',
        ),
      ];
      final newState = state.copyWith(
        groups: newGroups,
        isLoading: true,
      );

      expect(newState.groups, newGroups);
      expect(newState.isLoading, true);
    });
  });

  group('IdolGroupListNotifier', () {
    test('initializeでアイドルグループのリストを取得', () async {
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.groups.length, 1);
      expect(notifier.state.groups.first.name, 'test group');
      verify(mockLogger.i('アイドルグループのリストを取得中...')).called(1);
      verify(mockLogger.i('アイドルグループのリストを1件取得しました')).called(1);
    });

    test('initializeでエラーが発生した場合は例外をスロー', () async {
      var didThrowError = false;
      try {
        await notifier.initialize(
          supabase: errorSupabase,
          logger: mockLogger,
        );
      } catch (e, stackTrace) {
        didThrowError = true;
        verify(
          mockLogger.e(
            'アイドルグループのリストを取得中にエラーが発生しました',
            error: e,
            stackTrace: stackTrace,
          ),
        ).called(1);
      }
      expect(didThrowError, isTrue);
    });

    test('addGroup', () async {
      final newGroup = IdolGroup(
        name: 'test group2',
        imageUrl: 'https://example.com/test2.jpg',
      );
      notifier.addGroup(newGroup, logger: mockLogger);

      expect(notifier.state.groups.length, 2);
      expect(notifier.state.groups.last.name, 'test group2');
      verify(mockLogger.i('アイドルグループを追加しています: test group2')).called(1);
    });

    test('removeGroup', () {
      expect(notifier.state.groups.length, 1);
      notifier.removeGroup(
        notifier.state.groups.first,
        logger: mockLogger,
      );
      expect(notifier.state.groups.isEmpty, isTrue);
    });

    test('getGroupByID', () {
      expect(notifier.state.groups.length, 1);
      expect(notifier.getGroupById(1, logger: mockLogger), isA<IdolGroup>());
      try {
        expect(notifier.getGroupById(2, logger: mockLogger), isNull);
        verify(mockLogger.e('IDが 2 のアイドルグループが見つかりませんでした')).called(1);
      } catch (e, stackTrace) {
        verify(
          mockLogger.e(
            'ID:2 のグループを見つける際にエラーが発生しました',
            error: e,
            stackTrace: stackTrace,
          ),
        ).called(1);
      }
    });
  });

  group('idolGroupListProvider', () {
    test('プロバイダーの初期化', () async {
      final container = ProviderContainer(
        overrides: [
          groupsProvider.overrideWith(
            (ref) => notifier,
          ),
        ],
      );

      await container
          .read(groupsProvider.notifier)
          .initialize(supabase: mockSupabase, logger: mockLogger);

      final state = container.read(groupsProvider);

      verify(mockLogger.i('アイドルグループのリストを取得中...')).called(2);

      expect(state, isA<GroupsState>());
      expect(state.groups.length, 1);
      expect(state.groups.first.name, 'test group');
    });
  });
}
