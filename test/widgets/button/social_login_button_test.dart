import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/widgets/button/social_login_button.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('SocialLoginButtonウィジェット', (WidgetTester tester) async {
    var isLogin = false;
    void socialLogin() {
      isLogin = true;
    }

    final imagePath = 'assets/images/google.svg';
    await tester.pumpWidget(
      buildTestWidget(
        child: SocialLoginButton(socialLogin, imagePath: imagePath),
      ),
    );

    // 表示テスト
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);

    // SvgPictureのプロパティを確認
    final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    // 本来SvgPictureクラスのbytesLoaderはBytesLoader型だが
    // SvgPicture.assetの場合はSvgAssetLoader型に変換される
    final svgAssetLoader = svgPicture.bytesLoader as SvgAssetLoader;
    expect(svgAssetLoader.assetName, imagePath);
    expect(svgPicture.height, 40.0);
    expect(svgPicture.width, 40.0);

    // タップテスト
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(isLogin, isTrue);
  });
}
