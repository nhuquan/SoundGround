part of 'playlists_bloc.dart';

@immutable
sealed class PlaylistsEvent {}

class GetPlaylistsEvent extends PlaylistsEvent {}

class CreatePlaylistEvent extends PlaylistsEvent {
  final String name;

  CreatePlaylistEvent(this.name);
}

class DeletePlaylistEvent extends PlaylistsEvent {
  final int playlistId;

  DeletePlaylistEvent(this.playlistId);
}

class RenamePlaylistEvent extends PlaylistsEvent {
  final int playlistId;
  final String name;

  RenamePlaylistEvent(this.playlistId, this.name);
}

class GetPlaylistSongsEvent extends PlaylistsEvent {
  final int playlistId;

  GetPlaylistSongsEvent(this.playlistId);
}

class AddSongToPlaylistEvent extends PlaylistsEvent {
  final int playlistId;
  final SongModel song;

  AddSongToPlaylistEvent(this.playlistId, this.song);
}

class RemoveSongFromPlaylistEvent extends PlaylistsEvent {
  final int playlistId;
  final SongModel song;

  RemoveSongFromPlaylistEvent(this.playlistId, this.song);
}
