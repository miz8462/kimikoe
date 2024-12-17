import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';

class IdolListOfGroupNotifier extends StateNotifier<AsyncValue<List<Idol>>> {
  IdolListOfGroupNotifier(this.ref, this.groupId)
      : super(const AsyncLoading()) {
    fetchIdols();
  }

  final Ref ref;
  final int groupId;

  Future<void> fetchIdols() async {
    try {
      final group =
          ref.watch(idolGroupListProvider.notifier).getGroupById(groupId);
      logger.i('SupabaseからID $groupId のアイドルリストを取得中...');
      final response = await supabase
          .from(TableName.idols)
          .select()
          .eq(ColumnName.groupId, groupId);

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

      logger.i('SupabaseからID $groupId のアイドルリストを取得しました。データ数は${idols.length}個です');
      state = AsyncData(idols);
    } catch (e, stackTrace) {
      logger.e(
        'ID:$groupId のアイドルリストを取得中にエラーが発生しました',
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

final idolListOfGroupProvider = StateNotifierProvider.family<
    IdolListOfGroupNotifier, AsyncValue<List<Idol>>, int>(
  IdolListOfGroupNotifier.new,
);
