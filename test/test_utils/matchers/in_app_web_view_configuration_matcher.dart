import 'package:matcher/matcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class InAppWebViewConfigurationMatcher extends Matcher {
  InAppWebViewConfigurationMatcher(this._expected);
  final InAppWebViewConfiguration _expected;

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is! InAppWebViewConfiguration) return false;
    return item.enableJavaScript == _expected.enableJavaScript &&
        item.enableDomStorage == _expected.enableDomStorage &&
        _compareHeaders(item.headers, _expected.headers);
  }

  @override
  Description describe(Description description) =>
      description.add('matches InAppWebViewConfiguration with properties: '
          'enableJavaScript: ${_expected.enableJavaScript}, '
          'enableDomStorage: ${_expected.enableDomStorage}, '
          'headers: ${_expected.headers}');

  bool _compareHeaders(
    Map<String, String> headers1,
    Map<String, String> headers2,
  ) {
    if (headers1.length != headers2.length) return false;
    for (final key in headers1.keys) {
      if (headers1[key] != headers2[key]) return false;
    }
    return true;
  }
}
