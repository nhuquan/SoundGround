import 'package:get_it/get_it.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_ground/src/bloc/favorites/favorites_bloc.dart';
import 'package:sound_ground/src/bloc/home/home_bloc.dart';
import 'package:sound_ground/src/bloc/language/language_cubit.dart';
import 'package:sound_ground/src/bloc/player/player_bloc.dart';
import 'package:sound_ground/src/bloc/playlists/playlists_bloc.dart';
import 'package:sound_ground/src/bloc/recents/recents_bloc.dart';
import 'package:sound_ground/src/bloc/scan/scan_cubit.dart';
import 'package:sound_ground/src/bloc/search/search_bloc.dart';
import 'package:sound_ground/src/bloc/song/song_bloc.dart';
import 'package:sound_ground/src/bloc/theme/theme_bloc.dart';
import 'package:sound_ground/src/data/repositories/favorites_repository.dart';
import 'package:sound_ground/src/data/repositories/home_repository.dart';
import 'package:sound_ground/src/data/repositories/player_repository.dart';
import 'package:sound_ground/src/data/repositories/playlists_repository.dart';
import 'package:sound_ground/src/data/repositories/recents_repository.dart';
import 'package:sound_ground/src/data/repositories/search_repository.dart';
import 'package:sound_ground/src/data/repositories/song_repository.dart';
import 'package:sound_ground/src/data/repositories/theme_repository.dart';

final sl = GetIt.instance;

void init() {
  // Bloc
  sl.registerFactory(() => ThemeBloc(repository: sl()));
  sl.registerFactory(() => HomeBloc(repository: sl()));
  sl.registerFactory(() => PlayerBloc(repository: sl()));
  sl.registerFactory(() => SongBloc(repository: sl()));
  sl.registerFactory(() => FavoritesBloc(repository: sl()));
  sl.registerFactory(() => RecentsBloc(repository: sl()));
  sl.registerFactory(() => SearchBloc(repository: sl()));
  sl.registerFactory(() => PlaylistsBloc(repository: sl()));

  // Cubit
  sl.registerFactory(() => ScanCubit());
  sl.registerFactory(() => LanguageCubit());

  // Repository
  sl.registerLazySingleton(() => ThemeRepository());
  sl.registerLazySingleton(() => HomeRepository());
  sl.registerLazySingleton<MusicPlayer>(
    () => JustAudioPlayer(),
  );
  sl.registerLazySingleton(() => SongRepository());
  sl.registerLazySingleton(() => FavoritesRepository());
  sl.registerLazySingleton(() => RecentsRepository());
  sl.registerLazySingleton(() => SearchRepository());
  sl.registerLazySingleton(() => PlaylistsRepository());

  // Third Party
  sl.registerLazySingleton(() => OnAudioQuery());
}
