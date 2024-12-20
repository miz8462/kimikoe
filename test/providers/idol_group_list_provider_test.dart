import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';

void main() {
  group('IdolGroupListState', () {
    test('クラスの初期化', () {
      final state = IdolGroupListState();

      expect(state, isA<IdolGroupListState>());
      expect(state.groups, isA<List<IdolGroup>>());
      expect(state.isLoading, isFalse);
    });

    test('クラスをcopyWithで上書き', () {
      final state = IdolGroupListState();
      final newGroups = [
        IdolGroup(
          name: 'test group',
          imageUrl: 'https://example.com/test.jpg',
        ),
      ];
      final newState = state.copyWith(
        groups: newGroups,
        isLoading: true,
      );

      expect(newState.groups, newGroups);
      expect(newState.isLoading, true);
    });
  });

  group('IdolGroupListNotifier', () {
    test('クラスの初期化', () {
      final notifier = IdolGroupListNotifier();
      print(notifier);
      // expect(notifier);
    });
  });
}
