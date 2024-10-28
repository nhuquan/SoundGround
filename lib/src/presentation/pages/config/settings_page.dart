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
                    showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (BuildContext context) {
                          return BlocProvider.value(
                            value: BlocProvider.of<ThemeBloc>(context),
                            child: _DropdownBottomSheetItemContainer(
                              child: Column(
                                children: [
                                  DropdownBottomSheetItem<String>(
                                    item: 'en',
                                    child: ListTile(
                                      title: const Text('English'),
                                      onTap: () {
                                        // change language
                                        context
                                            .read<LanguageCubit>()
                                            .changeLang('en');
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  DropdownBottomSheetItem<String>(
                                    item: 'vi',
                                    child: ListTile(
                                      title: const Text('Vietnamese'),
                                      onTap: () {
                                        // change language
                                        context
                                            .read<LanguageCubit>()
                                            .changeLang('vi');
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
                // package info
                _buildPackageInfoTile(context),
              ],
            ),
          ),
        );
      },
    );
  }

  ListTile _buildPackageInfoTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(context.l10n.settingsPageVersionButton),
      subtitle: Text(
        _packageInfo.version,
      ),
      onTap: () async {
        // show package info
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Package info'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${_packageInfo.appName}',
                ),
                Text(
                  'Package: ${_packageInfo.packageName}',
                ),
                Text(
                  'Version: ${_packageInfo.version}',
                ),
                Text(
                  'Build number: ${_packageInfo.buildNumber}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
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
