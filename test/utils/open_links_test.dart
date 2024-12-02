import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/open_links.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../test_utils/matchers/in_app_browser_configuration_matcher.dart';
import '../test_utils/matchers/in_app_web_view_configuration_matcher.dart';
import 'open_links_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UrlLauncherPlatform>()])
void main() {
  group(
    'openAppOrWeb関数のテスト',
    () {
      late MockUrlLauncherPlatform mockUrlLauncher;

      setUp(() {
        mockUrlLauncher = MockUrlLauncherPlatform();
        // インスタンスをモックに入れ替える。依存性の注入(DI)
        UrlLauncherPlatform.instance = mockUrlLauncher;
      });

      test(
        'deepLinkUrlが開ける場合',
        () async {
          // canLaunchUrl関数は以下のように定義されている。
          /* 
      Future<bool> canLaunchUrl(Uri url) async {
        return UrlLauncherPlatform.instance.canLaunch(url.toString());
      }　   
      */
          // なので関数呼び出しもcanLaunchUrlではなくcanLaunchである。
          final deepLinkUrl = Uri.parse('app://deep-link');
          final webUrl = Uri.parse('phhtps://example.com');
          final LaunchOptions options = LaunchOptions(
            mode: PreferredLaunchMode.platformDefault,
            webViewConfiguration: const InAppWebViewConfiguration(),
            browserConfiguration: const InAppBrowserConfiguration(),
            webOnlyWindowName: null,
          ); // launchUrlの引数のため

          // モックの動作を定義
          when(mockUrlLauncher.canLaunch(deepLinkUrl.toString()))
              .thenAnswer((_) async => true);
          when(mockUrlLauncher.launchUrl(deepLinkUrl.toString(), options))
              .thenAnswer((_) async => true);

          // 実際の動作
          await openAppOrWeb(deepLinkUrl, webUrl);

          // モックの動作を検証
          // オプションの検証がverify関数だけだとうまくいかなかったので
          // matcherを作成し検証
          final capturedOptions = verify(
                  mockUrlLauncher.launchUrl(deepLinkUrl.toString(), captureAny))
              .captured
              .single as LaunchOptions;
          expect(capturedOptions.mode,
              equals(PreferredLaunchMode.externalApplication));
          expect(
              capturedOptions.webViewConfiguration,
              InAppWebViewConfigurationMatcher(
                  const InAppWebViewConfiguration()));
          expect(
              capturedOptions.browserConfiguration,
              InAppBrowserConfigurationMatcher(
                  const InAppBrowserConfiguration()));
          expect(capturedOptions.webOnlyWindowName, options.webOnlyWindowName);
        },
      );
    },
  );
}
