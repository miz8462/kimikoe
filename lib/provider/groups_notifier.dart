import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/idol_group.dart';

class IdolGroupsNotifier extends StateNotifier<List<IdolGroup>> {
  IdolGroupsNotifier() : super(const []);

  void addGroup(
    String name,
    String? image,
    int? year,
    String comment,
  ) {
    final newGroup = IdolGroup(
      name: name,
      imageUrl: image,
      year: year,
      comment: comment,
    );
    state = [newGroup, ...state];
  }
}

final groupsProvider = StateNotifierProvider<IdolGroupsNotifier, List<IdolGroup>>(
  (ref) => IdolGroupsNotifier(),
);
