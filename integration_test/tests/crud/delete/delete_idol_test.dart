import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('アイドル削除', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    await supabase.from(TableName.idols).insert({
      ColumnName.name: 'test-idol',
      ColumnName.groupId: 162, // test-groupのid
      ColumnName.color: 0xffffffff,
      ColumnName.imageUrl: noImage,
    });

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);

    // 削除
    await naviRobot.toTestIdolDetail(groupName: 'test-group');
    await naviRobot.tapTopBarMenu();
    await naviRobot.tapDelete();
    await naviRobot.tapDeleteYes();
    naviRobot.expectDeleteMessage(name: 'test-idol');
  });
}
