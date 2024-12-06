import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class InAppBrowserConfigurationMatcher extends Matcher {
  InAppBrowserConfigurationMatcher(this._expected);
  final InAppBrowserConfiguration _expected;

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is! InAppBrowserConfiguration) return false;
    return item.showTitle == _expected.showTitle;
  }

  @override
  Description describe(Description description) =>
      description.add('matches InAppBrowserConfiguration with property: '
          'showTitle: ${_expected.showTitle}');
}
