// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteNotifierHash() => r'7fd2f65eb23dead821b1a5d44e353f058fe973a6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FavoriteNotifier extends BuildlessAsyncNotifier<List<int>> {
  late final FavoriteType type;

  FutureOr<List<int>> build(
    FavoriteType type,
  );
}

/// See also [FavoriteNotifier].
@ProviderFor(FavoriteNotifier)
const favoriteNotifierProvider = FavoriteNotifierFamily();

/// See also [FavoriteNotifier].
class FavoriteNotifierFamily extends Family<AsyncValue<List<int>>> {
  /// See also [FavoriteNotifier].
  const FavoriteNotifierFamily();

  /// See also [FavoriteNotifier].
  FavoriteNotifierProvider call(
    FavoriteType type,
  ) {
    return FavoriteNotifierProvider(
      type,
    );
  }

  @override
  FavoriteNotifierProvider getProviderOverride(
    covariant FavoriteNotifierProvider provider,
  ) {
    return call(
      provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'favoriteNotifierProvider';
}

/// See also [FavoriteNotifier].
class FavoriteNotifierProvider
    extends AsyncNotifierProviderImpl<FavoriteNotifier, List<int>> {
  /// See also [FavoriteNotifier].
  FavoriteNotifierProvider(
    FavoriteType type,
  ) : this._internal(
          () => FavoriteNotifier()..type = type,
          from: favoriteNotifierProvider,
          name: r'favoriteNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$favoriteNotifierHash,
          dependencies: FavoriteNotifierFamily._dependencies,
          allTransitiveDependencies:
              FavoriteNotifierFamily._allTransitiveDependencies,
          type: type,
        );

  FavoriteNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final FavoriteType type;

  @override
  FutureOr<List<int>> runNotifierBuild(
    covariant FavoriteNotifier notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(FavoriteNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: FavoriteNotifierProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<FavoriteNotifier, List<int>> createElement() {
    return _FavoriteNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteNotifierProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FavoriteNotifierRef on AsyncNotifierProviderRef<List<int>> {
  /// The parameter `type` of this provider.
  FavoriteType get type;
}

class _FavoriteNotifierProviderElement
    extends AsyncNotifierProviderElement<FavoriteNotifier, List<int>>
    with FavoriteNotifierRef {
  _FavoriteNotifierProviderElement(super.provider);

  @override
  FavoriteType get type => (origin as FavoriteNotifierProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
