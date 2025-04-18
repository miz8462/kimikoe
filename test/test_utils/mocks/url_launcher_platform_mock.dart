// Mocks generated by Mockito 5.4.4 from annotations
// in kimikoe_app/test/utils/open_links_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [UrlLauncherPlatform].
///
/// See the documentation for Mockito's code generation for more information.
class MockUrlLauncherPlatform extends _i1.Mock
    with MockPlatformInterfaceMixin
    implements _i2.UrlLauncherPlatform {
  @override
  _i3.Future<bool> canLaunch(String? url) => (super.noSuchMethod(
        Invocation.method(
          #canLaunch,
          [url],
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> launch(
    String? url, {
    required bool? useSafariVC,
    required bool? useWebView,
    required bool? enableJavaScript,
    required bool? enableDomStorage,
    required bool? universalLinksOnly,
    required Map<String, String>? headers,
    String? webOnlyWindowName,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #launch,
          [url],
          {
            #useSafariVC: useSafariVC,
            #useWebView: useWebView,
            #enableJavaScript: enableJavaScript,
            #enableDomStorage: enableDomStorage,
            #universalLinksOnly: universalLinksOnly,
            #headers: headers,
            #webOnlyWindowName: webOnlyWindowName,
          },
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> launchUrl(
    String? url,
    _i2.LaunchOptions? options,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #launchUrl,
          [
            url,
            options,
          ],
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<void> closeWebView() => (super.noSuchMethod(
        Invocation.method(
          #closeWebView,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<bool> supportsMode(_i2.PreferredLaunchMode? mode) =>
      (super.noSuchMethod(
        Invocation.method(
          #supportsMode,
          [mode],
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> supportsCloseForMode(_i2.PreferredLaunchMode? mode) =>
      (super.noSuchMethod(
        Invocation.method(
          #supportsCloseForMode,
          [mode],
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}
