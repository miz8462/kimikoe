import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class InAppBrowserConfigurationMatcher extends Matcher {
  final InAppBrowserConfiguration _expected;

  InAppBrowserConfigurationMatcher(this._expected);

  @override
  bool matches(item, Map matchState) {
    if (item is! InAppBrowserConfiguration) return false;
    return item.showTitle == _expected.showTitle;
  }

  @override
  Description describe(Description description) =>
      description.add('matches InAppBrowserConfiguration with property: '
          'showTitle: ${_expected.showTitle}');
}
