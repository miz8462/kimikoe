import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/form_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('歌詞登録', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toAddSong();

    final title = 'test-song';
    final lyric = 'test-lyric';
    final singer = 'test-singer';
    final now = DateTime.now();
    final today = formatDateTimeToXXXX(date: now, formatStyle: 'yyyy/MM/dd');
    final comment = 'test-comment';
    final formRobot = FormRobot(tester);
    await formRobot.enterTitle(title);
    await formRobot.selectGroup();
    await formRobot.tapWidget(WidgetKeys.addLyric);
    await formRobot.ensureVisibleWidget(WidgetKeys.lyric0);
    await formRobot.enterLyric(lyric);
    await formRobot.ensureVisibleWidget(WidgetKeys.singer0);
    await formRobot.selectImage();
    await formRobot.enterLyric(singer);
    await formRobot.selectSinger();
    await formRobot.selectArtist(WidgetKeys.lyricist);
    await formRobot.selectArtist(WidgetKeys.composer);
    await formRobot.pickDate(today, WidgetKeys.releaseDate);
    await formRobot.enterComment(comment);
    await formRobot.ensureSubmitButton();
    await formRobot.tapSubmitButton();

    await formRobot.waitForWidget(IdolGroupListScreen);
    formRobot.expectSuccessMessage(dataType: '曲', name: title);

    await formRobot.deleteTestData(
      table: TableName.songs,
      columnName: ColumnName.title,
      name: title,
    );
  });

  testWidgets('歌詞ヴァリデーション', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toAddSong();

    final formRobot = FormRobot(tester);

    await formRobot.ensureSubmitButton();
    await formRobot.tapSubmitButton();
    await formRobot.ensureVisibleWidget(WidgetKeys.title);
    formRobot.expectValidationMessage(dataType: 'タイトル');
  });
}
