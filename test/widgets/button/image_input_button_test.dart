import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/widgets/button/image_input_button.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';

import '../../test_utils/test_widgets.dart';

// TODO: 画像選択テスト
void main() {
  group('ImageInputウィジェット', () {
    testWidgets('ImageInputウィジェット初期状態テスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: ImageInputButton(label: 'test label', onPickImage: (_) {}),
        ),
      );

      final button = find.byType(StyledButton);
      expect(button, findsOneWidget);
      expect(find.text('test label'), findsOneWidget);
      final buttonWidget = tester.widget<StyledButton>(button);
      expect(buttonWidget.backgroundColor, equals(mainColor.withOpacity(0.8)));
    });
  });
}
