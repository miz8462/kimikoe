import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/dropdown_id_and_name.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/widgets/form/custom_dropdown_menu.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('CustomDropdownMenu', (tester) async {
    final mockDataList = [
      {
        ColumnName.id: 1,
        ColumnName.name: 'Option1',
      },
      {
        ColumnName.id: 2,
        ColumnName.name: 'Option2',
      },
    ];
    final controller = TextEditingController();

    await tester.pumpWidget(
      buildTestWidget(
        child: CustomDropdownMenu(
          label: 'Test Label',
          dataList: mockDataList,
          controller: controller,
        ),
      ),
    );

    expect(find.text('Test Label'), findsOneWidget);

    // ドロップダウンメニューを開く
    await tester.tap(find.byType(DropdownMenu<DropdownIdAndName>));
    await tester.pumpAndSettle();

    // おそらくはdropdownの仕様上、Textウィジェットの下にRichTextウィジェットが生成され'Option1'が2つが生成される
    // そのうちRichTextの方を選択する
    final option1TextFinder = find.text('Option1').last;
    expect(option1TextFinder, findsOneWidget);

    // Option1を選択
    await tester.tap(option1TextFinder);
    await tester.pumpAndSettle();
    
    // 選択した値を確認
    expect(controller.text, 'Option1');
  });
}
