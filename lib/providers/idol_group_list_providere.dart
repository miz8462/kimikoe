import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';

// 二つ以上の状態を管理する場合Stateクラスを別に作って管理するといい
class IdolGroupListState {
  IdolGroupListState({
    this.groups = const [],
    this.isLoading = false,
  });
  final List<IdolGroup> groups;
  final bool isLoading;

  IdolGroupListState copyWith({
    List<IdolGroup>? groups,
    bool? isLoading,
  }) {
    return IdolGroupListState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class IdolGroupListNotifier extends StateNotifier<IdolGroupListState> {
  IdolGroupListNotifier() : super(IdolGroupListState());

  Future<void> initialize() async {
    await fetchGroupList();
  }

  Future<void> fetchGroupList() async {
    try {
      logger.i('アイドルグループのリストを取得中...');
      state = state.copyWith(isLoading: true);

      final data = await fetchDataByStream(
        table: TableName.idolGroups,
        id: ColumnName.id,
        supabase: supabase,
        logger: logger,
      ).first as List<Map<String, dynamic>>;

      final groups = data.map<IdolGroup>((group) {
        return IdolGroup(
          id: group[ColumnName.id],
          name: group[ColumnName.name],
          imageUrl: group[ColumnName.imageUrl],
          year: group[ColumnName.yearFormingGroups],
          officialUrl: group[ColumnName.officialUrl],
          twitterUrl: group[ColumnName.twitterUrl],
          instagramUrl: group[ColumnName.instagramUrl],
          scheduleUrl: group[ColumnName.scheduleUrl],
          comment: group[ColumnName.comment],
        );
      }).toList();
      logger.i('アイドルグループのリストを${groups.length}件取得しました');
      state = state.copyWith(groups: groups, isLoading: false);
    } catch (e, stackTrace) {
      logger.e('アイドルグループのリストを取得中にエラーが発生しました', error: e, stackTrace: stackTrace);
    }
  }

  void addGroup(IdolGroup newGroup) {
    logger.i('アイドルグループを追加しています: ${newGroup.name}');
    state = state.copyWith(groups: [...state.groups, newGroup]);
  }

  void removeGroup(IdolGroup group) {
    logger.i('アイドルグループを削除しています: ${group.name}');
    state = state.copyWith(
      groups: state.groups.where((g) => g.id != group.id).toList(),
    );
  }

  IdolGroup? getGroupById(int id) {
    try {
      return state.groups.firstWhere(
        (group) => group.id == id,
        orElse: () {
          logger.e('IDが $id のグループが見つかりませんでした');
          throw StateError('IDが $id のグループが見つかりませんでした');
        },
      );
    } catch (e, stackTrace) {
      logger.e(
        'ID:$id のグループを見つける際にエラーが発生しました',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}

final idolGroupListProvider =
    StateNotifierProvider<IdolGroupListNotifier, IdolGroupListState>((ref) {
  final notifier = IdolGroupListNotifier();
  notifier.initialize();
  return notifier;
});
