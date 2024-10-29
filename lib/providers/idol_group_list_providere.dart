import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class IdolGroupListNotifier extends StateNotifier<List<IdolGroup>> {
  IdolGroupListNotifier() : super([]) {
    fetchGroupList();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchGroupList() async {
    _isLoading = true;
    state =[];
    final data = await fetchDatabyStream(
      table: TableName.idolGroups.name,
      id: ColumnName.id.name,
    ).first;
    final groups = data.map<IdolGroup>((group) {
      final imageUrl = fetchPublicImageUrl(group[ColumnName.imageUrl.name]);
      return IdolGroup(
        id: group[ColumnName.id.name],
        name: group[ColumnName.cName.name],
        imageUrl: imageUrl,
        year: group[ColumnName.yearFormingGroups.name],
        comment: group[ColumnName.comment.name],
      );
    }).toList();
    state = groups;
    _isLoading = false;
  }

  void addGroup(IdolGroup group) {
    state = [...state, group];
  }

  void removeGroup(IdolGroup group) {
    state = state.where((g) => g.id != group.id).toList();
  }

  IdolGroup? getGroupById(int id) {
    return state.firstWhere((group) => group.id == id, orElse: () {
      throw StateError('Group with id: $id not found');
    });
  }
}

final idolGroupListProvider =
    StateNotifierProvider<IdolGroupListNotifier, List<IdolGroup>>(
        (ref) => IdolGroupListNotifier());

// final idolGroupListProvider =
//     StateNotifierProvider<IdolGroupListNotifier, List<IdolGroup>>((ref) {
//   final notifier = IdolGroupListNotifier();
//   notifier.fetchGroupList();
//   return notifier;
// });

// final idolGroupListFromSupabaseProvider =
//     FutureProvider<List<IdolGroup>>((ref) async {
//   final data = await fetchDatabyStream(
//     table: TableName.idolGroups.name,
//     id: ColumnName.id.name,
//   ).first;
//   return data.map<IdolGroup>((group) {
//     final imageUrl = fetchPublicImageUrl(group[ColumnName.imageUrl.name]);
//     return IdolGroup(
//       id: group[ColumnName.id.name],
//       name: group[ColumnName.cName.name],
//       imageUrl: imageUrl,
//       year: group[ColumnName.yearFormingGroups.name],
//       comment: group[ColumnName.comment.name],
//     );
//   }).toList();
// });
