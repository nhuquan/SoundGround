import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_ground/src/core/di/service_locator.dart';
import 'package:sound_ground/src/data/services/hive_box.dart';

class PlaylistsRepository {
  final box = Hive.box(HiveBox.boxName);

  OnAudioQuery audioQuery = sl<OnAudioQuery>();
  List<PlaylistModel> playlists = [];

  Future<List<PlaylistModel>> getPlayLists() async {
    playlists = await audioQuery.queryPlaylists();
    return playlists.toList();
  }

  Future<List<PlaylistModel>> createPlaylist(String name) async {
    await audioQuery.createPlaylist(name);
    return await getPlayLists();
  }

  Future<List<PlaylistModel>> deletePlaylist(int playlistId) async {
    await audioQuery.removePlaylist(playlistId);
    return await getPlayLists();
  }

  Future<List<PlaylistModel>> renamePlaylist(
      int playlistId, String newName) async {
    await audioQuery.renamePlaylist(playlistId, newName);
    return await getPlayLists();
  }

  Future<List<SongModel>> getPlaylistSongs(int playlistId) async {
    List<SongModel> playlistSongs = await audioQuery.queryAudiosFrom(
      AudiosFromType.PLAYLIST,
      playlistId,
    );
    List<SongModel> allSongs = await audioQuery.querySongs(); // FIXME
    allSongs.removeWhere(
      (song) => !playlistSongs.any((element) => element.data == song.data),
    );
    return allSongs;
  }

  Future<List<SongModel>> addToPlaylist(int playlistId, SongModel song) async {
    await audioQuery.addToPlaylist(playlistId, song.id);
    return await getPlaylistSongs(playlistId);
  }

  Future<List<SongModel>> removeFromPlaylist(int playlistId, int songId) async {
    await audioQuery.removeFromPlaylist(playlistId, songId);
    return await getPlaylistSongs(playlistId);
  }
}
