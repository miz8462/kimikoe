import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:mockito/mockito.dart';

class MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  @override
  Future<bool> canLaunch(String url) {
    return Future.value(true);
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) {
    return Future.value(true);
  }
}
