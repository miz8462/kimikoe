import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';

class IdolListOfGroupNotifier extends StateNotifier<List<Idol>> {
  IdolListOfGroupNotifier(super.state);

  Idol? getIdolById(int id) {
    return state.firstWhere((idol) => idol.id == id, orElse: () {
      throw StateError('Idol with id:$id not fount');
    });
  }
}

final idolListOfGroupProvider =
    StateNotifierProvider.family<IdolListOfGroupNotifier, List<Idol>, int>(
        (ref, groupId) {
  final asyncValue = ref.watch(idolListOfGroupFromSupabaseProvider(groupId));
  return asyncValue.maybeWhen(
      data: (data) => IdolListOfGroupNotifier(data),
      orElse: () => IdolListOfGroupNotifier([]));
});

final idolListOfGroupFromSupabaseProvider =
    FutureProvider.family<List<Idol>, int>((ref, groupId) async {
  final group = ref.watch(idolGroupListProvider.notifier).getGroupById(groupId);

  final response = await supabase
      .from(TableName.idol)
      .select()
      .eq(ColumnName.groupId, groupId);
  return response.map((idol) {
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
});
