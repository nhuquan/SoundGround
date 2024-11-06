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
  String get settingsPageAboutButton => 'About';

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
  String get aboutPageTitle => 'Thank you!';

  @override
  String get aboutPageSubtitle => 'We deeply appreciate your support in using this app. It’s users like you who make our work worthwhile. If you’re enjoying the experience and would like to support us further, consider checking out our Patreon page. Your support, no matter how small, helps us improve and bring new features to life!';

  @override
  String get aboutPageQRHint => 'Use this QR code if you have a Vietnamese bank account, Or';

  @override
  String get aboutPageEnding => 'Drop me an email if you have any questions or feedback, thank you!';

  @override
  String get aboutPagePatreonButton => 'Support on Patreon';

  @override
  String get searchBoxHintText => 'Search';
}
