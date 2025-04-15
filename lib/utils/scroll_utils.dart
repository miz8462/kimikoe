import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/bottom_bar_visibility/bottom_bar_visibility_provider.dart';

class ScrollUtils {
  static bool handleScrollNotification(
    ScrollNotification notification,
    WidgetRef ref, {
    required double lastScrollOffset,
    double sensitivityThreshold = 50, // ボトムバーの表示/非表示の感度
  }) {
    final notifier = ref.read(bottomBarVisibilityNotifierProvider.notifier);

    if (notification is ScrollUpdateNotification) {
      final scrollOffset = notification.metrics.pixels;
      final delta = scrollOffset - lastScrollOffset;

      if (delta.abs() > sensitivityThreshold) {
        if (delta > 0) {
          notifier.hide();
        } else if (delta < 0) {
          notifier.show();
        }
      }
      return true;
    }
    return false;
  }
}
