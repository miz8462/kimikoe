import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/widgets/form/custom_dropdown_menu.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/form_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('曲を登録する', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester, container);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toAddSong();

    final title = 'test-song';
    final movieURL = 'https://example.com';
    final lyric = 'test-lyric';
    final now = DateTime.now();
    final today = formatDateTimeToXXXX(date: now, formatStyle: 'yyyy/MM/dd');
    final comment = 'test-comment';
    final formRobot = FormRobot(tester, container);
    await formRobot.enterTitle(title);
    await formRobot.selectGroup();
    await formRobot.ensureVisibleWidget('${WidgetKeys.lyric}_0');
    await formRobot.enterLyric(lyric);
    await formRobot.ensureVisibleWidgetWithText(
      widgetType: CustomDropdownMenu,
      childText: '*歌手1',
    );
    await formRobot.selectSinger();
    await formRobot.enterMovieUrl(movieURL);
    await formRobot.selectLyricist();
    await formRobot.selectComposer();
    await formRobot.pickDate(today, WidgetKeys.releaseDate);
    await formRobot.enterComment(comment);
    await formRobot.tapSubmitButton();

    await formRobot.waitForWidget(IdolGroupListScreen);
    formRobot.expectSuccessMessage(dataType: '曲', name: title);

    await formRobot.deleteTestData(
      table: TableName.songs,
      columnName: ColumnName.title,
      name: title,
    );
  });
}
