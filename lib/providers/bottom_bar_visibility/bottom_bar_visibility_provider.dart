import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_bar_visibility_provider.g.dart';

@riverpod
class BottomBarVisibilityNotifier extends _$BottomBarVisibilityNotifier {
  @override
  bool build() => true;

  void updateVisibility(double scrollOffset, {double threshold = 50}) {
    state = scrollOffset <= threshold;
  }

  void show() => state = true;
  void hide() => state = false;
}
