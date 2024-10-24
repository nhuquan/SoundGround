import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_ground/src/bloc/player/player_bloc.dart';
import 'package:sound_ground/src/bloc/song/song_bloc.dart';
import 'package:sound_ground/src/core/di/service_locator.dart';
import 'package:sound_ground/src/data/repositories/player_repository.dart';
import 'package:sound_ground/src/data/repositories/song_repository.dart';
import 'package:sound_ground/src/presentation/widgets/animated_favorite_button.dart';
import 'package:sound_ground/src/presentation/widgets/seek_bar.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    super.key,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final player = sl<MusicPlayer>();
  SequenceState? sequence;

  @override
  void initState() {
    super.initState();

    player.sequenceState.listen((state) {
      setState(() {
        sequence = state;
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
        actions: [
          // more button
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert_outlined,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    showSleepTimer(context);
                  },
                  child: const Text('Sleep timer'),
                ),
              ];
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: StreamBuilder<SequenceState?>(
        stream: player.sequenceState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final sequence = snapshot.data;
          MediaItem? mediaItem = sequence!.sequence[sequence.currentIndex].tag;
          return Stack(
            children: [
              QueryArtworkWidget(
                keepOldArtwork: true,
                artworkHeight: double.infinity,
                id: int.parse(mediaItem!.id),
                type: ArtworkType.AUDIO,
                size: 10000,
                artworkWidth: double.infinity,
                artworkBorder: BorderRadius.circular(0),
                nullArtworkWidget: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: const Icon(
                    Icons.music_note_outlined,
                    size: 100,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  32,
                  MediaQuery.of(context).padding.top + 16,
                  32,
                  16,
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  // large screen
                  if (constraints.maxWidth > 600) {
                    // large screen divided in 2 columns
                    // 1: artwork
                    // 2: info
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // artwork
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              QueryArtworkWidget(
                                keepOldArtwork: true,
                                id: int.parse(mediaItem.id),
                                type: ArtworkType.AUDIO,
                                size: 10000,
                                artworkWidth: double.infinity,
                                nullArtworkWidget: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.music_note_outlined,
                                    size:
                                        MediaQuery.of(context).size.height / 10,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: BlocBuilder<SongBloc, SongState>(
                                  builder: (context, state) {
                                    return AnimatedFavoriteButton(
                                      isFavorite: sl<SongRepository>()
                                          .isFavorite(mediaItem.id),
                                      onTap: () {
                                        context.read<SongBloc>().add(
                                              ToggleFavorite(mediaItem.id),
                                            );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 32),

                        // info
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              // title and artist
                              StreamBuilder<SequenceState?>(
                                stream: player.sequenceState,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox.shrink();
                                  }
                                  final sequence = snapshot.data;

                                  MediaItem? mediaItem = sequence!
                                      .sequence[sequence.currentIndex].tag;

                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: mediaItem!.title.length > 50
                                            ? Marquee(
                                                text: mediaItem.title,
                                                blankSpace: 100,
                                                startAfter:
                                                    const Duration(seconds: 3),
                                                pauseAfterRound:
                                                    const Duration(seconds: 3),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                mediaItem.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                      Text(
                                        mediaItem.artist ?? 'Unknown',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const Spacer(),
                              // seek bar
                              SeekBar(player: player),
                              const Spacer(),
                              // shuffle, previous, play/pause, next, repeat
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //  shuffle button
                                  _buildShuffleButton(),
                                  // previous button
                                  _buildPreviousButton(context),
                                  // play/pause button
                                  _buildPlayPauseButton(),
                                  // next button
                                  _buildNextButton(context),
                                  // repeat button
                                  _buildRepeatButton(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  // small screen
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // artwork
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width - 64,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            QueryArtworkWidget(
                              keepOldArtwork: true,
                              id: int.parse(mediaItem.id),
                              type: ArtworkType.AUDIO,
                              size: 10000,
                              artworkWidth: double.infinity,
                              nullArtworkWidget: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.music_note_outlined,
                                  size: MediaQuery.of(context).size.height / 10,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: BlocBuilder<SongBloc, SongState>(
                                builder: (context, state) {
                                  return AnimatedFavoriteButton(
                                    isFavorite: sl<SongRepository>()
                                        .isFavorite(mediaItem.id),
                                    onTap: () {
                                      context.read<SongBloc>().add(
                                            ToggleFavorite(mediaItem.id),
                                          );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // title and artist
                      StreamBuilder<SequenceState?>(
                        stream: player.sequenceState,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }
                          final sequence = snapshot.data;

                          MediaItem? mediaItem =
                              sequence!.sequence[sequence.currentIndex].tag;
                          String artisName = mediaItem?.artist ?? '-';
                          if (artisName == '<unknown>') {
                            artisName = '-';
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                child: mediaItem!.title.length > 30
                                    ? Marquee(
                                        text: mediaItem.title,
                                        blankSpace: 100,
                                        startAfter: const Duration(seconds: 3),
                                        pauseAfterRound:
                                            const Duration(seconds: 3),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        mediaItem.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              Text(
                                artisName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 64),
                      // seek bar
                      SeekBar(player: player),
                      const SizedBox(height: 16),
                      // shuffle, previous, play/pause, next, repeat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //  shuffle button
                          _buildShuffleButton(),
                          // previous button
                          _buildPreviousButton(context),
                          // play/pause button
                          _buildPlayPauseButton(),
                          // next button
                          _buildNextButton(context),
                          // repeat button
                          _buildRepeatButton(),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  StreamBuilder<bool> _buildShuffleButton() {
    return StreamBuilder<bool>(
      stream: player.shuffleModeEnabled,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () async {
            context.read<PlayerBloc>().add(
                  PlayerSetShuffleModeEnabled(
                    !(snapshot.data ?? false),
                  ),
                );
          },
          icon: snapshot.data == false
              ? const Icon(
                  Icons.shuffle_outlined,
                  color: Colors.grey,
                )
              : const Icon(
                  Icons.shuffle_outlined,
                  color: Colors.white,
                ),
          iconSize: 30,
          tooltip: 'Shuffle',
        );
      },
    );
  }

  IconButton _buildPreviousButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<PlayerBloc>().add(PlayerPrevious());
      },
      icon: const Icon(
        Icons.skip_previous_outlined,
        color: Colors.white,
      ),
      iconSize: 40,
      tooltip: 'Previous',
    );
  }

  StreamBuilder<bool> _buildPlayPauseButton() {
    return StreamBuilder<bool>(
      stream: player.playing,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;
        return IconButton(
          onPressed: () {
            if (playing) {
              context.read<PlayerBloc>().add(PlayerPause());
            } else {
              context.read<PlayerBloc>().add(PlayerPlay());
            }
          },
          icon: playing
              ? const Icon(
                  Icons.pause_outlined,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.play_arrow_outlined,
                  color: Colors.white,
                ),
          iconSize: 40,
          tooltip: 'Play/Pause',
        );
      },
    );
  }

  IconButton _buildNextButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<PlayerBloc>().add(PlayerNext());
      },
      icon: const Icon(
        Icons.skip_next_outlined,
        color: Colors.white,
      ),
      iconSize: 40,
      tooltip: 'Next',
    );
  }

  StreamBuilder<LoopMode> _buildRepeatButton() {
    return StreamBuilder<LoopMode>(
      stream: player.loopMode,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () {
            if (snapshot.data == LoopMode.off) {
              context.read<PlayerBloc>().add(
                    PlayerSetLoopMode(LoopMode.all),
                  );
            } else if (snapshot.data == LoopMode.all) {
              context.read<PlayerBloc>().add(
                    PlayerSetLoopMode(LoopMode.one),
                  );
            } else {
              context.read<PlayerBloc>().add(
                    PlayerSetLoopMode(LoopMode.off),
                  );
            }
          },
          icon: snapshot.data == LoopMode.off
              ? const Icon(
                  Icons.repeat_outlined,
                  color: Colors.grey,
                )
              : snapshot.data == LoopMode.all
                  ? const Icon(
                      Icons.repeat_outlined,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.repeat_one_outlined,
                      color: Colors.white,
                    ),
          iconSize: 30,
          tooltip: 'Repeat',
        );
      },
    );
  }

  void showSleepTimer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                title: const Text('Off'),
                onTap: () {
                  // context.read<PlayerBloc>().add(PlayerSetSleepTimer(null));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('5 minutes'),
                onTap: () {
                  // context.read<PlayerBloc>().add(
                  //       PlayerSetSleepTimer(
                  //         const Duration(minutes: 5),
                  //       ),
                  //     );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('10 minutes'),
                onTap: () {
                  // context.read<PlayerBloc>().add(
                  //       PlayerSetSleepTimer(
                  //         const Duration(minutes: 10),
                  //       ),
                  //     );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('15 minutes'),
                onTap: () {
                  // context.read<PlayerBloc>().add(
                  //       PlayerSetSleepTimer(
                  //         const Duration(minutes: 15),
                  //       ),
                  //     );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('30 minutes'),
                onTap: () {
                  // context.read<PlayerBloc>().add(
                  //       PlayerSetSleepTimer(
                  //         const Duration(minutes: 30),
                  //       ),
                  //     );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('45 minutes'),
                onTap: () {
                  // context.read<PlayerBloc>().add(
                  //       PlayerSetSleepTimer(
                  //         const Duration(minutes: 45),
                  //       ),
                  //     );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('1 hour'),
                onTap: () {
                  // context.read<PlayerBloc>().add(
                  //       PlayerSetSleepTimer(
                  //         const Duration(hours: 1),
                  //       ),
                  //     );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
