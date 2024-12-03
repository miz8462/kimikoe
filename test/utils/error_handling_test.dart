import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/error_handling.dart';

import '../test_utils/test_widgets.dart';

void main() {
  testWidgets('handleMemberFetchErrorウィジェットのテスト', (tester) async {
    final error = Exception('Fetch error');
    final widget = handleMemberFetchError(error);
    await tester.pumpWidget(buildTestWidget(child: widget));

    expect(find.text('メンバー情報の取得に失敗しました。後でもう一度お試しください。'), findsOneWidget);
  });
}
