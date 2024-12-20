import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sound_ground/src/bloc/language/language_cubit.dart';
import 'package:sound_ground/src/bloc/theme/theme_bloc.dart';
import 'package:sound_ground/src/core/router/app_router.dart';
import 'package:sound_ground/src/core/theme/themes.dart';
import 'package:sound_ground/src/l10n/build_context_ext.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _getPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();

    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Themes.getTheme().secondaryColor,
          appBar: AppBar(
            backgroundColor: Themes.getTheme().primaryColor,
            elevation: 0,
            title: Text(context.l10n.settingsPageTitle),
          ),
          body: Ink(
            padding: const EdgeInsets.fromLTRB(
              0,
              16,
              0,
              16,
            ),
            decoration: BoxDecoration(
              gradient: Themes.getTheme().linearGradient,
            ),
            child: ListView(
              children: [
                // scan music (ignores songs which don't satisfy the requirements)
                ListTile(
                  leading: const Icon(Icons.wifi_tethering_outlined),
                  title: Text(context.l10n.settingsPageScanMusicButton),
                  subtitle: Text(
                    context.l10n.settingsPageScanMusicButtonSubtitle,
                  ),
                  onTap: () async {
                    Navigator.of(context).pushNamed(AppRouter.scanRoute);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(context.l10n.settingsPageLanguageButton),
                  onTap: () async {
                    _buildModalBottomSheet(context);
                  },
                ),
                // package info
                ListTile(
                  leading: const Icon(Icons.headset_mic_outlined),
                  title: Text(context.l10n.settingsPageAboutButton),
                  onTap: () async {
                    Navigator.of(context).pushNamed(AppRouter.aboutRoute);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _buildModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: BlocProvider.of<ThemeBloc>(context),
            child: Wrap(
              children: [
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    // change language
                    context.read<LanguageCubit>().changeLang('en');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Vietnamese'),
                  onTap: () {
                    // change language
                    context.read<LanguageCubit>().changeLang('vi');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}

class _DropdownBottomSheetItemContainer extends StatelessWidget {
  const _DropdownBottomSheetItemContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
            color: Colors.transparent,
            child: child),
      ],
    );
  }
}

class DropdownBottomSheetItem<T> extends _DropdownBottomSheetItemContainer {
  const DropdownBottomSheetItem(
      {super.key, required this.item, required super.child});

  final T? item;
}
