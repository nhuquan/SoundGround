import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_ground/src/data/repositories/playlists_repository.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  PlaylistsBloc({required PlaylistsRepository repository})
      : super(PlaylistsInitial()) {
    //
    on<GetPlaylistsEvent>((event, emit) async {
      try {
        final playlists = await repository.getPlayLists();
        emit(PlaylistsLoaded(playlists));
      } catch (e) {
        emit(PlaylistsError(e.toString()));
      }
    });

    on<CreatePlaylistEvent>((event, emit) async {
      debugPrint('create playlist');
      try {
        final playlists = await repository.createPlaylist(event.name);
        emit(PlaylistsLoaded(playlists));
      } catch (e) {
        emit(PlaylistsError(e.toString()));
      }
    });

    on<RenamePlaylistEvent>((event, emit) async {
      debugPrint('rename playlist ${event.playlistId} ${event.name}');
      try {
        final playlists =
            await repository.renamePlaylist(event.playlistId, event.name);
        emit(PlaylistsLoaded(playlists));
      } catch (e) {
        emit(PlaylistsError(e.toString()));
      }
      debugPrint('rename done');
    });

    on<DeletePlaylistEvent>((event, emit) async {
      debugPrint('delete playlist');
      try {
        final playlists = await repository.deletePlaylist(event.playlistId);
        emit(PlaylistsLoaded(playlists));
      } catch (e) {
        emit(PlaylistsError(e.toString()));
      }
    });

    on<GetPlaylistSongsEvent>((event, emit) async {
      try {
        final songs = await repository.getPlaylistSongs(event.playlistId);
        emit(PlaylistsSongsLoaded(songs));
      } catch (e) {
        emit(PlaylistsError(e.toString()));
      }
    });

    on<AddSongToPlaylistEvent>((event, emit) async {
      debugPrint('add song to playlist');
      List<SongModel> songs =
          await repository.addToPlaylist(event.playlistId, event.song);
      List<PlaylistModel> playlists = await repository.getPlayLists();
      emit(PlaylistsSongsLoaded(songs));
      emit(PlaylistsLoaded(playlists));
    });

    on<RemoveSongFromPlaylistEvent>((event, emit) async {
      debugPrint('remove song from playlist');
      List<SongModel> songs =
          await repository.removeFromPlaylist(event.playlistId, event.song.id);
      List<PlaylistModel> playlists = await repository.getPlayLists();
      emit(PlaylistsSongsLoaded(songs));
      emit(PlaylistsLoaded(playlists));
    });
  }
}
