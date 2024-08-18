import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/model/group.dart';

class GroupsNotifier extends StateNotifier<List<Group>> {
  GroupsNotifier() : super(const []);

  void addGroup(
    String name,
    // File? image,
    int year,
    String comment,
  ) {
    final newGroup = Group(
      name: name,
      // image: image,
      year: year,
      comment: comment,
    );
    state = [newGroup, ...state];
  }
}

final groupsProvider = StateNotifierProvider<GroupsNotifier, List<Group>>(
  (ref) => GroupsNotifier(),
);
