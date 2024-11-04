part of 'playlists_bloc.dart';

@immutable
sealed class PlaylistsState {}

final class PlaylistsInitial extends PlaylistsState {}

final class PlaylistsError extends PlaylistsState {
  final String message;
  PlaylistsError(this.message);
}

final class PlaylistsLoaded extends PlaylistsState {
  final List<PlaylistModel> playlists;
  PlaylistsLoaded(this.playlists);
}

final class PlaylistsSongsLoaded extends PlaylistsState {
  final List<SongModel> songs;
  PlaylistsSongsLoaded(this.songs);
}
