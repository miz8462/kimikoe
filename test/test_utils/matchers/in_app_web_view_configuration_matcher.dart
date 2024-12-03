import 'package:matcher/matcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class InAppWebViewConfigurationMatcher extends Matcher {
  final InAppWebViewConfiguration _expected;

  InAppWebViewConfigurationMatcher(this._expected);

  @override
  bool matches(item, Map matchState) {
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
    for (String key in headers1.keys) {
      if (headers1[key] != headers2[key]) return false;
    }
    return true;
  }
}
