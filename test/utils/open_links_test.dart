// TODO: mockを学んでから
// 何をやってもhttpclientがステータスコード200しか返さない。

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/utils/open_links.dart';
import 'package:mockito/mockito.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../test_utils/matchers/in_app_browser_configuration_matcher.dart';
import '../test_utils/matchers/in_app_web_view_configuration_matcher.dart';
import '../test_utils/mocks/http_client_mock.dart';
import '../test_utils/mocks/url_launcher_platform_mock.dart';

void main() {
  late MockUrlLauncherPlatform mockUrlLauncher;
  late MockClient mockClient;

  setUp(() {
    mockUrlLauncher = MockUrlLauncherPlatform();
    // インスタンスをモックに入れ替える。依存性の注入(DI)
    UrlLauncherPlatform.instance = mockUrlLauncher;
    mockClient = MockClient();
  });
  final deepLinkUrl = Uri.parse('app://deep-link');

  final url = Uri.parse('https://example.com');
  final strUrl = 'https://example.com';

  final invalidUrl = Uri.parse('invalid-url');
  final strInvalidUrl = 'invalid-url';

  final options = LaunchOptions(); // launchUrlの引数のため

  group(
    'openAppOrWeb関数のテスト',
    () {
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

          // モックの動作を定義
          when(mockUrlLauncher.canLaunch(deepLinkUrl.toString()))
              .thenAnswer((_) async => true);
          when(mockUrlLauncher.launchUrl(deepLinkUrl.toString(), options))
              .thenAnswer((_) async => true);

          // 実際の動作
          await openAppOrWeb(deepLinkUrl, url);

          // モックの動作を検証
          // オプションの検証がverify関数だけだとうまくいかなかったので
          // matcherを作成し検証
          final capturedOptions = verify(
            mockUrlLauncher.launchUrl(deepLinkUrl.toString(), captureAny),
          ).captured.single as LaunchOptions;
          expect(
            capturedOptions.mode,
            equals(PreferredLaunchMode.externalApplication),
          );
          expect(
            capturedOptions.webViewConfiguration,
            InAppWebViewConfigurationMatcher(
              const InAppWebViewConfiguration(),
            ),
          );
          expect(
            capturedOptions.browserConfiguration,
            InAppBrowserConfigurationMatcher(
              const InAppBrowserConfiguration(),
            ),
          );
          expect(capturedOptions.webOnlyWindowName, options.webOnlyWindowName);
        },
      );
      // ほぼほぼdeepLinkの場合と同じ
      test('webUrlが開ける場合', () async {
        when(mockUrlLauncher.canLaunch(deepLinkUrl.toString()))
            .thenAnswer((_) async => false);
        when(mockUrlLauncher.canLaunch(url.toString()))
            .thenAnswer((_) async => true);
        when(
          mockUrlLauncher.launchUrl(
            url.toString(),
            options,
          ),
        ).thenAnswer((_) async => true);
        await openAppOrWeb(deepLinkUrl, url);
        final capturedOptions =
            verify(mockUrlLauncher.launchUrl(url.toString(), captureAny))
                .captured
                .single as LaunchOptions;
        expect(
          capturedOptions.mode,
          equals(PreferredLaunchMode.platformDefault),
        );
        expect(
          capturedOptions.webViewConfiguration,
          InAppWebViewConfigurationMatcher(
            const InAppWebViewConfiguration(),
          ),
        );
        expect(
          capturedOptions.browserConfiguration,
          InAppBrowserConfigurationMatcher(
            const InAppBrowserConfiguration(),
          ),
        );
        expect(capturedOptions.webOnlyWindowName, options.webOnlyWindowName);
      });
      test(
        'どちらのURLも開けない場合',
        () async {
          when(
            mockUrlLauncher.canLaunch(
              deepLinkUrl.toString(),
            ),
          ).thenAnswer((_) async => false);
          when(
            mockUrlLauncher.canLaunch(
              url.toString(),
            ),
          ).thenAnswer((_) async => false);

          try {
            await openAppOrWeb(deepLinkUrl, url);
            fail('例外がスローされていません');
          } catch (e) {
            expect(
              e.toString(),
              equals('Exception: どちらのURLも開くことができません: $deepLinkUrl, $url'),
            );
          }
        },
      );
    },
  );

  // openAppOrWebの後半と同じ
  group('openWebSite関数', () {
    test('URLを開くことができる場合', () async {
      when(mockUrlLauncher.canLaunch(url.toString()))
          .thenAnswer((_) async => true);
      when(mockUrlLauncher.launchUrl(url.toString(), options))
          .thenAnswer((_) async => true);
      await openWebSite(url);
      final capturedOptions =
          verify(mockUrlLauncher.launchUrl(url.toString(), captureAny))
              .captured
              .single as LaunchOptions;
      expect(capturedOptions.mode, equals(PreferredLaunchMode.platformDefault));
      expect(
        capturedOptions.webViewConfiguration,
        InAppWebViewConfigurationMatcher(const InAppWebViewConfiguration()),
      );
      expect(
        capturedOptions.browserConfiguration,
        InAppBrowserConfigurationMatcher(const InAppBrowserConfiguration()),
      );
      expect(capturedOptions.webOnlyWindowName, options.webOnlyWindowName);
    });
    test('URLを開くことができない場合', () async {
      when(mockUrlLauncher.canLaunch(url.toString()))
          .thenAnswer((_) async => false);
      try {
        await openWebSite(url);
        fail('例外がスローされていません');
      } catch (e) {
        expect(
          e.toString(),
          equals('Exception: 開くことができません: $url'),
        );
      }
    });
  });
  group('isUrlExist関数', () {
    test('URLが存在し、HEADリクエストが成功', () async {
      when(mockClient.head(url))
          .thenAnswer((_) async => http.Response('', 200));
      final result = await isUrlExists(url.toString());
      expect(result, isTrue);
    });
    test('URLが存在し、HEADリクエストが失敗しGETリクエストが成功', () async {
      when(mockClient.head(url))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      when(mockClient.get(url)).thenAnswer((_) async => http.Response('', 200));
      final result = await isUrlExists(url.toString(), client: mockClient);
      expect(result, isTrue);
    });
    test('URLが存在しない場合 (HEADとGETリクエストが失敗)', () async {
      when(mockClient.head(url))
          .thenAnswer((_) async => http.Response('', 404));
      when(mockClient.get(url)).thenAnswer((_) async => http.Response('', 404));
      final result = await isUrlExists(url.toString(), client: mockClient);
      expect(result, isFalse);
    });
    test('URLが無効な場合（例外が発生）', () async {
      when(mockClient.head(invalidUrl))
          .thenThrow(FormatException('Invalid URL'));
      expect(
        () async => isUrlExists(strInvalidUrl, client: mockClient),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('convertUrlStringToUri関数', () {
    test('urlが存在する場合', () async {
      // isUrlExists関数に依存してるのでモックする
      when(mockClient.head(any))
          .thenAnswer((_) async => http.Response('', 200));
      final result = await convertUrlStringToUri(strUrl, client: mockClient);
      expect(result, equals(Uri.parse(strUrl)));
    });
    test('urlが存在しない場合', () async {
      when(mockClient.head(any))
          .thenAnswer((_) async => http.Response('', 404));
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('', 404));
      final result = await convertUrlStringToUri(strUrl, client: mockClient);
      expect(result, isNull);
    });
    test('無効なURLの場合、例外が発生する', () async {
      final url = 'invalid-url';
      when(mockClient.head(any)).thenThrow(FormatException('Invalid URL'));
      final result = await convertUrlStringToUri(url, client: mockClient);
      expect(result, isNull);
    });
  });

  group('createDeepLinkFromWebUrl関数', () {
    test('twitterのdeepLinkが生成される', () {
      final twitterUrl = Uri.parse('https://twitter.com/username_miu');
      final result = createDeepLinkFromWebUrl(twitterUrl, twitterScheme);
      expect(result, Uri.parse('twitter://user?screen_name=username_miu'));
    });
    test('instagramのdeepLinkが生成される', () {
      final instagramUrl = Uri.parse('https://instagram.com/username_miu');
      final result = createDeepLinkFromWebUrl(instagramUrl, instagramScheme);
      expect(result, Uri.parse('instagram://user?username_name=username_miu'));
    });
    test('webUrlがnullの場合はnullが返される', () {
      final result = createDeepLinkFromWebUrl(null, instagramScheme);
      expect(result, isNull);
    });
    test('schemeがnullの場合はnullが返される', () {
      final instagramUrl = Uri.parse('https://instagram.com/username_miu');

      final result = createDeepLinkFromWebUrl(instagramUrl, null);
      expect(result, isNull);
    });
  });
}
