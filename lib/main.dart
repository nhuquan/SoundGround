import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_ground/src/app.dart';
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
import 'package:sound_ground/src/core/di/service_locator.dart';
import 'package:sound_ground/src/data/repositories/player_repository.dart';
import 'package:sound_ground/src/data/services/hive_box.dart';

Future<void> main() async {
  // initialize flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // initialize dependency injection
  init();

  // ask for permission to access media if not granted
  if (!await Permission.mediaLibrary.isGranted) {
    await Permission.mediaLibrary.request();
  }

  // initialize hive
  await Hive.initFlutter();
  await Hive.openBox(HiveBox.boxName);

  // initialize audio service
  await sl<MusicPlayer>().init();

  // run app
  runApp(
    MyAppWithFeedback(),
  );
}

class MyAppWithFeedback extends StatelessWidget {
  const MyAppWithFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      localeOverride: const Locale('en'),
      mode: FeedbackMode.draw,
      pixelRatio: 1,
      darkTheme: FeedbackThemeData.dark(),
      theme: FeedbackThemeData(
        background: Colors.grey,
        feedbackSheetColor: Colors.grey[50]!,
        drawColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
          Colors.purple,
        ],
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<HomeBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<ThemeBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<SongBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<FavoritesBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<PlayerBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<RecentsBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<SearchBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<ScanCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<PlaylistsBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<LanguageCubit>(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  }
}
