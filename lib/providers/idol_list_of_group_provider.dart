import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class IdolListOfGroupNotifier extends StateNotifier<List<Idol>> {
  IdolListOfGroupNotifier(super.state);

  void addIdol(Idol idol) {
    state = [...state, idol];
  }

  void removeIdol(Idol idol) {
    state = state.where((i) => i.id != idol.id).toList();
  }

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
      .from(TableName.idol.name)
      .select()
      .eq(ColumnName.groupId.name, groupId);
  return response.map((idol) {
    final imageUrl = fetchPublicImageUrl(idol[ColumnName.imageUrl.name]);
    return Idol(
      id: idol[ColumnName.id.name],
      name: idol[ColumnName.cName.name],
      group: group,
      imageUrl: imageUrl,
      birthDay: idol[ColumnName.birthday.name],
      birthYear: idol[ColumnName.birthYear.name],
      color: Color(int.parse(idol[ColumnName.color.name])),
      debutYear: idol[ColumnName.debutYear.name],
      height: idol[ColumnName.height.name],
      hometown: idol[ColumnName.hometown.name],
      instagramUrl: idol[ColumnName.instagramUrl.name],
      officialUrl: idol[ColumnName.officialUrl.name],
      twitterUrl: idol[ColumnName.twitterUrl.name],
      comment: idol[ColumnName.comment.name],
    );
  }).toList();
});
