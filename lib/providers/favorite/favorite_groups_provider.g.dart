// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_groups_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteGroupsHash() => r'eb90cb1141f377133fe99a667387f76bb9f30006';

/// See also [fetchFavoriteGroups].
@ProviderFor(fetchFavoriteGroups)
final favoriteGroupsProvider = FutureProvider<List<IdolGroup>>.internal(
  fetchFavoriteGroups,
  name: r'favoriteGroupsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteGroupsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteGroupsRef = FutureProviderRef<List<IdolGroup>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
