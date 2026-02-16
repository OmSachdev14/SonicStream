import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotufy/core/constants/server_constant.dart';
import 'package:spotufy/core/failure/failure.dart';
import 'package:spotufy/features/home/model/song_model.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong(
      {required File selectedAudio,
      required File selectedImage,
      required String songName,
      required String artist,
      required String hexCode,
      required String token}) async {
    try {
      final reqest = http.MultipartRequest(
          'POST', Uri.parse('${ServerConstant.serverURL}/song/upload'));
      reqest
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path)
        ])
        ..fields.addAll(
            {'artist': artist, 'song_name': songName, 'hex_code': hexCode})
        ..headers.addAll({'x-auth-token': token});

      final res = await reqest.send();
      if (res.statusCode != 201) {
        return Left(AppFailure(message: await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstant.serverURL}/song/list'), headers: {
        'Content-detail': 'application/json',
        'x-auth-token': token
      });
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(message: resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong(
      {required String token, required String songId}) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/song/favorite'),
        headers: {
          'Content-Type':
              'application/json', // ⚠️ Fixed typo: was 'Content-detail'
          'x-auth-token': token
        },
        body: jsonEncode({"song_id": songId}),
      );

      // ✅ Check status code BEFORE parsing
      if (res.statusCode != 200) {
        // Try to parse error response
        try {
          final resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;
          return Left(AppFailure(message: resBodyMap['detail'] ?? res.body));
        } catch (e) {
          // If error response isn't JSON, return raw body
          return Left(AppFailure(message: res.body));
        }
      }

      // ✅ Only parse JSON for successful responses
      final resBodyMap = jsonDecode(res.body);
      return Right(resBodyMap['message']?? false);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllFavSongs({
    required String token,
  }) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstant.serverURL}/song/list/favorites'), headers: {
        'Content-detail': 'application/json',
        'x-auth-token': token
      });
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(message: resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> favSongs = [];

      for (final map in resBodyMap) {
        favSongs.add(SongModel.fromMap(map['song']));
      }
      return Right(favSongs);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
