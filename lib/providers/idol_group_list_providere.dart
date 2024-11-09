import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

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
  IdolGroupListNotifier() : super(IdolGroupListState()) {
    fetchGroupList();
  }

  Future<void> fetchGroupList() async {
    state = state.copyWith(isLoading: true);
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
    state = state.copyWith(groups: groups, isLoading: false);
  }

  void addGroup(IdolGroup newGroup) {
    state = state.copyWith(groups: [...state.groups, newGroup]);
  }

  void removeGroup(IdolGroup group) {
    state = state.copyWith(
      groups: state.groups.where((g) => g.id != group.id).toList(),
    );
  }

  IdolGroup? getGroupById(int id) {
    return state.groups.firstWhere((group) => group.id == id, orElse: () {
      throw StateError('Group with id: $id not found');
    });
  }
}

final idolGroupListProvider =
    StateNotifierProvider<IdolGroupListNotifier, IdolGroupListState>(
        (ref) => IdolGroupListNotifier());
