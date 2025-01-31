import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:robot/robot.dart';

import '../integration_test_utils/wait_for_condition.dart';

class HomeRobot extends Robot<IdolGroupListScreen> {
  HomeRobot(super.tester);

  Future<void> refreshScreen() async {
    await tester.fling(
      find.byType(RefreshIndicator),
      const Offset(0, 300),
      1000,
    );
    await tester.pumpAndSettle();
  }

  Future<void> expectHomeScreen() async {
    await waitForCondition(tester, find.byType(IdolGroupListScreen));
    expect(find.byType(IdolGroupListScreen), findsOneWidget);
  }
}
