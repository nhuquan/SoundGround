import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_ground/src/bloc/language/language_cubit.dart';
import 'package:sound_ground/src/bloc/theme/theme_bloc.dart';
import 'package:sound_ground/src/core/constants/assets.dart';
import 'package:sound_ground/src/core/di/service_locator.dart';
import 'package:sound_ground/src/core/router/app_router.dart';
import 'package:sound_ground/src/core/theme/themes.dart';
import 'package:sound_ground/src/l10n/build_context_ext.dart';
import 'package:sound_ground/src/presentation/pages/home/views/artists_view.dart';
import 'package:sound_ground/src/presentation/pages/home/views/playlists_view.dart';
import 'package:sound_ground/src/presentation/pages/home/views/songs_view.dart';
import 'package:sound_ground/src/presentation/widgets/player_bottom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final OnAudioQuery _audioQuery = sl<OnAudioQuery>();
  late TabController _tabController;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  Future checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : checkAndRequestPermissions(retry: true);
  }

  final tabs = [
    'Songs',
    'Playlists',
    'Artists',
  ];

  @override
  Widget build(BuildContext context) {
    context.read<LanguageCubit>().changeStartLang();

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          // current song, play/pause button, song progress bar, song queue button
          bottomNavigationBar: const PlayerBottomAppBar(),
          extendBody: true,
          backgroundColor: Themes.getTheme().secondaryColor,
          drawer: _buildDrawer(context),
          appBar: _buildAppBar(),
          body: _buildBody(context),
        );
      },
    );
  }

  Ink _buildBody(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        gradient: Themes.getTheme().linearGradient,
      ),
      child: _hasPermission
          ? Column(
              children: [
                TabBar(
                    dividerColor:
                        Theme.of(context).colorScheme.onPrimary.withOpacity(
                              0.3,
                            ),
                    tabAlignment: TabAlignment.center,
                    isScrollable: true,
                    controller: _tabController,
                    tabs: [
                      Text(
                        context.l10n.homePageSongTabTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(context.l10n.homePagePlaylistTabTitle,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(context.l10n.homePageArtistsTabTitle,
                          style: Theme.of(context).textTheme.titleMedium),
                    ]),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      SongsView(),
                      PlaylistsView(),
                      ArtistsView(),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text('No permission to access library'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    // permission request
                    await Permission.storage.request();
                  },
                  child: const Text('Retry'),
                )
              ],
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Themes.getTheme().primaryColor,
      title: Text(context.l10n.appTitle,
          style: Theme.of(context).textTheme.titleLarge),
      // search button
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRouter.searchRoute);
          },
          icon: const Icon(Icons.search_outlined),
          tooltip: context.l10n.searchBoxHintText,
        )
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return DrawerHeader(
                decoration: BoxDecoration(
                  color: Themes.getTheme().primaryColor,
                ),
                child: Row(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        Assets.logo,
                        height: 64,
                        width: 64,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      context.l10n.appTitle,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // themes
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: Text(context.l10n.themePageTitle),
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.themesRoute);
            },
          ),
          // settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(context.l10n.settingsPageTitle),
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.settingsRoute);
            },
          )
        ],
      ),
    );
  }
}
