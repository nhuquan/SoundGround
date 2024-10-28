import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SoundGround';

  @override
  String get themePageTitle => 'Themes';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsPageScanMusicButton => 'Scan music';

  @override
  String get settingsPageScanMusicButtonSubtitle => 'Ignore songs which don\\\'t satisfy the requirements';

  @override
  String get settingsPageLanguageButton => 'Language';

  @override
  String get settingsPageVersionButton => 'Version';

  @override
  String get scanPageTitle => 'Scan';

  @override
  String get scanPageMinDuration => 'Ignore duration less than:';

  @override
  String get scanPageDurationUnit => 'seconds';

  @override
  String get scanPageMinSize => 'Ignore size less than:';

  @override
  String get homePageSongTabTitle => 'Songs';

  @override
  String get homePagePlaylistTabTitle => 'Playlists';

  @override
  String get homePageArtistsTabTitle => 'Artists';

  @override
  String get songViewSortBy => 'Sort by';

  @override
  String get songViewOrderBy => 'Order by';

  @override
  String get songViewToastMessage => 'songs found';

  @override
  String get songViewSongCount => 'songs';

  @override
  String get searchBoxHintText => 'Search';
}
