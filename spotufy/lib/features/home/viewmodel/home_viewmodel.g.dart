// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllSongsHash() => r'a53a3d396d1fb56df51c87f5b8268be0061ba2d3';

/// See also [getAllSongs].
@ProviderFor(getAllSongs)
final getAllSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getAllSongs,
  name: r'getAllSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$getAllFavSongsHash() => r'abb4b82fa450d6200b35d947dcb31b413cf20d00';

/// See also [getAllFavSongs].
@ProviderFor(getAllFavSongs)
final getAllFavSongsProvider =
    AutoDisposeFutureProvider<List<SongModel>>.internal(
  getAllFavSongs,
  name: r'getAllFavSongsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllFavSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllFavSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$homeViewmodelHash() => r'6624505bce8e0cd05075dc69912e6fe0ca043e89';

/// See also [HomeViewmodel].
@ProviderFor(HomeViewmodel)
final homeViewmodelProvider =
    AutoDisposeNotifierProvider<HomeViewmodel, AsyncValue?>.internal(
  HomeViewmodel.new,
  name: r'homeViewmodelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewmodelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewmodel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
