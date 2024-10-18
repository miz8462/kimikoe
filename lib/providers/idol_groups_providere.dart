import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class IdolGroupListNotifier extends StateNotifier<List<IdolGroup>> {
  IdolGroupListNotifier(super.state);

  void addGroup(IdolGroup group) {
    state = [...state, group];
  }

  void removeGroup(IdolGroup group) {
    state = state.where((g) => g.id != group.id).toList();
  }
}

final idolGroupListProvider =
    StateNotifierProvider<IdolGroupListNotifier, List<IdolGroup>>((ref) {
  final asyncValue = ref.watch(idolGroupListFromSupabaseProvider);
  return asyncValue.maybeWhen(
      data: (data) => IdolGroupListNotifier(data),
      orElse: () => IdolGroupListNotifier([]));
});

final idolGroupListFromSupabaseProvider =
    FutureProvider<List<IdolGroup>>((ref) async {
  final data = await fetchDatabyStream(
    table: TableName.idolGroups.name,
    id: ColumnName.id.name,
  ).first;
  return data.map<IdolGroup>((group) {
    final imageUrl = fetchPublicImageUrl(group[ColumnName.imageUrl.name]);
    return IdolGroup(
      id: group[ColumnName.id.name],
      name: group[ColumnName.cName.name],
      imageUrl: imageUrl,
      year: group[ColumnName.yearFormingGroups.name],
      comment: group[ColumnName.comment.name],
    );
  }).toList();
});
