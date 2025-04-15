import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/groups_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test_utils/test_utils.dart';

void main() {
  late GroupsNotifier notifier;
  late ProviderContainer container;
  late SupabaseClient mockSupabase;

  setUp(() async {
    container = await TestUtils.setupTestContainer();
    mockSupabase = Supabase.instance.client;

    // モックデータの設定
    await mockSupabase.from(TableName.idolGroups).insert([
      {
        ColumnName.id: 1,
        ColumnName.name: 'test group 1',
        ColumnName.imageUrl: 'https://example.com/test1.jpg',
      },
      {
        ColumnName.id: 2,
        ColumnName.name: 'test group 2',
        ColumnName.imageUrl: 'https://example.com/test2.jpg',
      },
    ]);

    notifier = container.read(groupsProvider.notifier);
    await notifier.initialize();
  });

  tearDown(() async {
    await TestUtils.cleanup();
    container.dispose();
  });

  group('GroupsState', () {
    test('初期状態の確認', () {
      final state = GroupsState();
      expect(state.groups, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('copyWithによる状態の更新', () {
      final state = GroupsState();
      final newGroups = [
        IdolGroup(
          id: 1,
          name: 'test group',
          imageUrl: 'https://example.com/test.jpg',
        ),
      ];

      final newState = state.copyWith(
        groups: newGroups,
        isLoading: true,
      );

      expect(newState.groups, newGroups);
      expect(newState.isLoading, isTrue);
    });
  });

  group('GroupsNotifier', () {
    test('initializeでグループリストを取得', () async {
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.groups.length, 2);
      expect(notifier.state.groups[0].name, 'test group 1');
      expect(notifier.state.groups[1].name, 'test group 2');
    });

    test('addGroupで新しいグループを追加', () {
      final newGroup = IdolGroup(
        id: 3,
        name: 'test group 3',
        imageUrl: 'https://example.com/test3.jpg',
      );

      notifier.addGroup(newGroup);
      expect(notifier.state.groups.length, 3);
      expect(notifier.state.groups.last, newGroup);
    });

    test('removeGroupでグループを削除', () {
      final initialLength = notifier.state.groups.length;
      final groupToRemove = notifier.state.groups.first;

      notifier.removeGroup(groupToRemove);
      expect(notifier.state.groups.length, initialLength - 1);
      expect(notifier.state.groups.contains(groupToRemove), isFalse);
    });

    test('getGroupByIdで存在するグループを取得', () {
      final group = notifier.getGroupById(1);
      expect(group, isNotNull);
      expect(group!.id, 1);
      expect(group.name, 'test group 1');
    });

    test('getGroupByIdで存在しないグループを取得しようとした場合', () {
      expect(
        () => notifier.getGroupById(999),
        throwsStateError,
      );
    });
  });

  group('GroupsProvider', () {
    test('プロバイダーの初期化と状態の確認', () async {
      final testContainer = await TestUtils.setupTestContainer();
      final provider = testContainer.read(groupsProvider.notifier);

      await provider.initialize();
      final state = testContainer.read(groupsProvider);

      expect(state, isA<GroupsState>());
      expect(state.groups.length, 2);
      expect(state.isLoading, isFalse);

      testContainer.dispose();
    });
  });
}
