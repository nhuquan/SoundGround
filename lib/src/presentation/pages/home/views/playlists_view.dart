import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_ground/src/bloc/playlists/playlists_bloc.dart';
import 'package:sound_ground/src/core/constants/assets.dart';
import 'package:sound_ground/src/core/extensions/string_extensions.dart';
import 'package:sound_ground/src/core/router/app_router.dart';

class PlaylistsView extends StatefulWidget {
  const PlaylistsView({super.key});

  @override
  State<PlaylistsView> createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends State<PlaylistsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<PlaylistModel> playlists = [];

  @override
  void initState() {
    super.initState();
    context.read<PlaylistsBloc>().add(GetPlaylistsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final cards = [
      const SizedBox(width: 16),
      PlaylistCard(
        image: Assets.heart,
        label: 'Favorites',
        icon: Icons.favorite_border_outlined,
        color: Colors.red,
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.favoritesRoute,
          );
        },
      ),
      const SizedBox(width: 16),
      PlaylistCard(
        image: Assets.earphones,
        label: 'Recents',
        icon: Icons.history_outlined,
        color: Colors.yellow,
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.recentsRoute,
          );
        },
      ),
      const SizedBox(width: 16),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...cards],
          ),
          const SizedBox(height: 20),

          // add playlist
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AddPlaylistDialog(
                  playlists: playlists,
                ),
              );
            },
            leading: const Icon(Icons.add),
            title: const Text('Add playlist'),
          ),

          // show playlists
          BlocListener<PlaylistsBloc, PlaylistsState>(
            listener: (context, state) {
              if (state is PlaylistsLoaded) {
                playlists = state.playlists;
              }
            },
            child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
              buildWhen: (previous, current) => current is PlaylistsLoaded,
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: playlists.length,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    return Slidable(
                      key: Key(playlist.id.toString()),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const BehindMotion(),
                        dragDismissible: false,
                        // A pane can dismiss the Slidable.
                        // dismissible: DismissiblePane(onDismissed: () {}),

                        // All actions are defined in the children parameter.
                        children: [
                          SlidableAction(
                            onPressed: (context) => {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _buildDeletePlaylistDialog(
                                        playlist,
                                        context,
                                      ))
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                          // SlidableAction(
                          //   onPressed: null,
                          //   backgroundColor: Color(0xFF21B7CA),
                          //   foregroundColor: Colors.white,
                          //   icon: Icons.share,
                          //   label: 'Share',
                          // ),
                        ],
                      ),

                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          // SlidableAction(
                          //   // An action can be bigger than the others.
                          //   // flex: 1,
                          //   onPressed: (context) => {
                          //     showDialog(
                          //         context: context,
                          //         builder: (context) => RenamePlaylistDialog(
                          //               playlist: playlist,
                          //             ))
                          //   },
                          //   backgroundColor: Color(0xFF7BC043),
                          //   foregroundColor: Colors.white,
                          //   icon: Icons.edit,
                          //   label: 'Rename',
                          // ),
                          SlidableAction(
                            onPressed: (context) => {
                              debugPrint('play playlist'),
                            },
                            backgroundColor: Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.play_arrow,
                            label: 'Play',
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.playlistDetailsRoute,
                            arguments: playlist,
                          );
                        },
                        leading: const Icon(Icons.music_note),
                        title: Text(playlist.playlist),
                        subtitle: Text(
                          '${playlist.numOfSongs} ${'song'.pluralize(playlist.numOfSongs)}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog _buildDeletePlaylistDialog(
    PlaylistModel playlist,
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text('Delete playlist'),
      content: Text('Are you sure you want to delete "${playlist.playlist}"?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            context.read<PlaylistsBloc>().add(DeletePlaylistEvent(playlist.id));
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final String image;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const PlaylistCard({
    super.key,
    required this.image,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.withOpacity(0.2),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 4),
                  Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class AddPlaylistDialog extends StatefulWidget {
  const AddPlaylistDialog({super.key, required this.playlists});

  final List<PlaylistModel> playlists;

  @override
  State<AddPlaylistDialog> createState() => _AddPlaylistDialogState();
}

class _AddPlaylistDialogState extends State<AddPlaylistDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add playlist'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Playlist name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Step 1: Gather playlist information
            String playlistName = _controller.text.trim();
            if (playlistName.isEmpty) {
              // return, show an error message if the name is empty
              Fluttertoast.showToast(msg: 'Playlist name cannot be empty');
              return;
            }

            // Step 2: Add playlist
            context
                .read<PlaylistsBloc>()
                .add(CreatePlaylistEvent(playlistName));

            // Step 3: Close dialog
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class RenamePlaylistDialog extends StatefulWidget {
  const RenamePlaylistDialog({super.key, required this.playlist});

  final PlaylistModel playlist;

  @override
  State<RenamePlaylistDialog> createState() => _RenamePlaylistDialog();
}

class _RenamePlaylistDialog extends State<RenamePlaylistDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename playlist'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Playlist name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Step 1: Gather playlist information
            String playlistName = _controller.text.trim();
            if (playlistName.isEmpty) {
              // return, show an error message if the name is empty
              Fluttertoast.showToast(msg: 'Playlist name cannot be empty');
              return;
            }

            // Step 2: Add playlist
            context
                .read<PlaylistsBloc>()
                .add(RenamePlaylistEvent(widget.playlist.id, playlistName));

            // Step 3: Close dialog
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
