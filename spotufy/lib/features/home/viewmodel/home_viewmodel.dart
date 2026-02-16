// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotufy/core/providers/current_user_notifier.dart';
import 'package:spotufy/core/widgets/utils.dart';
import 'package:spotufy/features/home/model/fav_songs.model.dart';
import 'package:spotufy/features/home/model/song_model.dart';
import 'package:spotufy/features/home/repository/home_local_repository.dart';
import 'package:spotufy/features/home/repository/home_repository.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r
  };
}

@riverpod
Future<List<SongModel>> getAllFavSongs(GetAllFavSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res =
      await ref.watch(homeRepositoryProvider).getAllFavSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r
  };
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong(
      {required File selectedAudio,
      required File selectedImage,
      required String songName,
      required String artist,
      required Color selectedColor}) async {
    state = const AsyncLoading();
    final res = await _homeRepository.uploadSong(
        selectedAudio: selectedAudio,
        selectedImage: selectedImage,
        songName: songName,
        artist: artist,
        hexCode: rgbToHex(selectedColor),
        token: ref.read(currentUserNotifierProvider)!.token);
    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r)
    };
    // print(val);
  }

  Future<void> favSong({required String songId}) async {
    state = const AsyncLoading();
    final res = await _homeRepository.favSong(
        songId: songId, token: ref.read(currentUserNotifierProvider)!.token);
    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId)
    };
    // print(val);
  }

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorited) {
      userNotifier
          .addUser(ref.read(currentUserNotifierProvider)!.copyWith(favorites: [
        ...ref.read(currentUserNotifierProvider)!.favorites,
        (FavSongsModel(id: '', song_id: songId, user_id: ''))
      ]));
    } else {
      userNotifier.addUser(ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: ref
              .read(currentUserNotifierProvider)!
              .favorites
              .where((fav) => fav.song_id != songId)
              .toList()));
    }
    ref.invalidate(getAllFavSongsProvider);
    return state = AsyncData(isFavorited);
  }

  List<SongModel> getRecentlyPlayedSong() {
    return _homeLocalRepository.loadSongs();
  }
}
