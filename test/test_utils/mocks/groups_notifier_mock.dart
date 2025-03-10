// Mocks generated by Mockito 5.4.4 from annotations
// in kimikoe_app/test/test_utils/mocks/a_mock_generater.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter_riverpod/flutter_riverpod.dart' as _i3;
import 'package:kimikoe_app/models/idol_group.dart' as _i6;
import 'package:kimikoe_app/providers/groups_provider.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:state_notifier/state_notifier.dart' as _i7;
import 'package:supabase_flutter/supabase_flutter.dart' as _i5;

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

class _FakeGroupsState_0 extends _i1.SmartFake implements _i2.GroupsState {
  _FakeGroupsState_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GroupsNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockGroupsNotifier extends _i1.Mock implements _i2.GroupsNotifier {
  @override
  set onError(_i3.ErrorListener? _onError) => super.noSuchMethod(
        Invocation.setter(
          #onError,
          _onError,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get mounted => (super.noSuchMethod(
        Invocation.getter(#mounted),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i4.Stream<_i2.GroupsState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i4.Stream<_i2.GroupsState>.empty(),
        returnValueForMissingStub: _i4.Stream<_i2.GroupsState>.empty(),
      ) as _i4.Stream<_i2.GroupsState>);

  @override
  _i2.GroupsState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeGroupsState_0(
          this,
          Invocation.getter(#state),
        ),
        returnValueForMissingStub: _FakeGroupsState_0(
          this,
          Invocation.getter(#state),
        ),
      ) as _i2.GroupsState);

  @override
  set state(_i2.GroupsState? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.GroupsState get debugState => (super.noSuchMethod(
        Invocation.getter(#debugState),
        returnValue: _FakeGroupsState_0(
          this,
          Invocation.getter(#debugState),
        ),
        returnValueForMissingStub: _FakeGroupsState_0(
          this,
          Invocation.getter(#debugState),
        ),
      ) as _i2.GroupsState);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i4.Future<void> initialize({required _i5.SupabaseClient? supabase}) =>
      (super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
          {#supabase: supabase},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> fetchGroupList({required _i5.SupabaseClient? supabase}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchGroupList,
          [],
          {#supabase: supabase},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void addGroup(_i6.IdolGroup? newGroup) => super.noSuchMethod(
        Invocation.method(
          #addGroup,
          [newGroup],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeGroup(_i6.IdolGroup? group) => super.noSuchMethod(
        Invocation.method(
          #removeGroup,
          [group],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i6.IdolGroup? getGroupById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #getGroupById,
          [id],
        ),
        returnValueForMissingStub: null,
      ) as _i6.IdolGroup?);

  @override
  bool updateShouldNotify(
    _i2.GroupsState? old,
    _i2.GroupsState? current,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateShouldNotify,
          [
            old,
            current,
          ],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i3.RemoveListener addListener(
    _i7.Listener<_i2.GroupsState>? listener, {
    bool? fireImmediately = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
          {#fireImmediately: fireImmediately},
        ),
        returnValue: () {},
        returnValueForMissingStub: () {},
      ) as _i3.RemoveListener);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
