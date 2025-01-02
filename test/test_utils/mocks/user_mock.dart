// Mocks generated by Mockito 5.4.4 from annotations
// in kimikoe_app/test/test_utils/mocks/a_mock_generater.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gotrue/src/types/user.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i3;

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

/// A class which mocks [User].
///
/// See the documentation for Mockito's code generation for more information.
class MockUser extends _i1.Mock implements _i2.User {
  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.getter(#id),
        ),
        returnValueForMissingStub: _i3.dummyValue<String>(
          this,
          Invocation.getter(#id),
        ),
      ) as String);

  @override
  Map<String, dynamic> get appMetadata => (super.noSuchMethod(
        Invocation.getter(#appMetadata),
        returnValue: <String, dynamic>{},
        returnValueForMissingStub: <String, dynamic>{},
      ) as Map<String, dynamic>);

  @override
  String get aud => (super.noSuchMethod(
        Invocation.getter(#aud),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.getter(#aud),
        ),
        returnValueForMissingStub: _i3.dummyValue<String>(
          this,
          Invocation.getter(#aud),
        ),
      ) as String);

  @override
  String get createdAt => (super.noSuchMethod(
        Invocation.getter(#createdAt),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.getter(#createdAt),
        ),
        returnValueForMissingStub: _i3.dummyValue<String>(
          this,
          Invocation.getter(#createdAt),
        ),
      ) as String);

  @override
  bool get isAnonymous => (super.noSuchMethod(
        Invocation.getter(#isAnonymous),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(
          #toJson,
          [],
        ),
        returnValue: <String, dynamic>{},
        returnValueForMissingStub: <String, dynamic>{},
      ) as Map<String, dynamic>);
}