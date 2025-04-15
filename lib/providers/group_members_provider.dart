import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/fetch_group_members_provider.dart';
import 'package:kimikoe_app/providers/groups_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';

class GroupMembersNotifier extends StateNotifier<AsyncValue<List<Idol>>> {
  GroupMembersNotifier(this.ref, this.groupId) : super(const AsyncLoading());

  final Ref ref;
  final int groupId;

  Future<void> initialize() async {
    return fetchIdols();
  }

  Future<void> fetchIdols() async {
    try {
      final groupsNotifier = ref.watch(groupsProvider.notifier);
      final group = groupsNotifier.getGroupById(groupId);
      final groupName = group!.name;
      logger.i('Supabaseから $groupName のメンバーリストを取得中...');

      final fechGroupMembers = ref.read(fetchGroupMembersProvider);
      final response = await fechGroupMembers(groupId);

      final idols = response.map((idol) {
        return Idol(
          id: idol[ColumnName.id],
          name: idol[ColumnName.name],
          group: group,
          imageUrl: idol[ColumnName.imageUrl],
          birthDay: idol[ColumnName.birthday],
          birthYear: idol[ColumnName.birthYear],
          color: Color(int.parse(idol[ColumnName.color])),
          debutYear: idol[ColumnName.debutYear],
          height: idol[ColumnName.height],
          hometown: idol[ColumnName.hometown],
          officialUrl: idol[ColumnName.officialUrl],
          twitterUrl: idol[ColumnName.twitterUrl],
          instagramUrl: idol[ColumnName.instagramUrl],
          otherUrl: idol[ColumnName.otherUrl],
          comment: idol[ColumnName.comment],
        );
      }).toList();

      logger.i('Supabaseから $groupName のメンバーリストを取得しました。メンバーは${idols.length}人です');
      state = AsyncData(idols);
    } catch (e, stackTrace) {
      logger.e(
        'ID:$groupId のメンバーリストを取得中にエラーが発生しました',
        error: e,
        stackTrace: stackTrace,
      );
      state = AsyncError(e, stackTrace);
    }
  }

  Idol? getIdolById(int id) {
    return state.value?.firstWhere(
      (idol) => idol.id == id,
      orElse: () {
        throw StateError('Idol with id:$id not fount');
      },
    );
  }
}

final groupMembersProvider = StateNotifierProvider.family<GroupMembersNotifier,
    AsyncValue<List<Idol>>, int>((ref, groupId) {
  final notifier = GroupMembersNotifier(ref, groupId);
  notifier.initialize();
  return notifier;
});
