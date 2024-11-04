// favorites_repository.dart
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_ground/src/core/di/service_locator.dart';
import 'package:sound_ground/src/data/services/hive_box.dart';

class FavoritesRepository {
  final box = Hive.box(HiveBox.boxName);

  //
  Future<List<SongModel>> fetchFavorites() async {
    List<String> favoriteSongsIds = box.get(
      HiveBox.favoriteSongsKey,
      defaultValue: List<String>.empty(),
    );

    OnAudioQuery audioQuery = sl<OnAudioQuery>();
    List<SongModel> songs = await audioQuery.querySongs(
      uriType: UriType.EXTERNAL,
    );

    return songs
        .where((song) => favoriteSongsIds.contains(song.id.toString()))
        .toList();
  }
}
