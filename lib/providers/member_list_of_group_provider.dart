import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';

class MemberListInGroupNotifier extends StateNotifier<AsyncValue<List<Idol>>> {
  MemberListInGroupNotifier(this.ref, this.groupId)
      : super(const AsyncLoading()) {
    fetchIdols();
  }

  final Ref ref;
  final int groupId;

  Future<void> fetchIdols() async {
    try {
      final group = ref.watch(idolGroupListProvider.notifier).getGroupById(
            groupId,
            logger: logger,
          );
      final groupName = group!.name;
      logger.i('Supabaseから $groupName のメンバーリストを取得中...');
      final response = await fetchGroupMembers(
        groupId,
        supabase: supabase,
        logger: logger,
      );

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

final memberListOfGroupProvider = StateNotifierProvider.family<
    MemberListInGroupNotifier, AsyncValue<List<Idol>>, int>(
  MemberListInGroupNotifier.new,
);
