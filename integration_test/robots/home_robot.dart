import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';

import 'custom_robot.dart';

class HomeRobot extends CustomRobot<IdolGroupListScreen> {
  HomeRobot(super.tester);

  Future<void> refreshScreen() async {
    await tester.fling(
      find.byType(RefreshIndicator),
      const Offset(0, 300),
      1000,
    );
    await tester.pumpAndSettle();
  }
}
