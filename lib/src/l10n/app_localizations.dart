import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SoundGround'**
  String get appTitle;

  /// No description provided for @themePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themePageTitle;

  /// No description provided for @settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @settingsPageScanMusicButton.
  ///
  /// In en, this message translates to:
  /// **'Scan music'**
  String get settingsPageScanMusicButton;

  /// No description provided for @settingsPageScanMusicButtonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ignore songs which don\\\'t satisfy the requirements'**
  String get settingsPageScanMusicButtonSubtitle;

  /// No description provided for @settingsPageLanguageButton.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsPageLanguageButton;

  /// No description provided for @settingsPageVersionButton.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsPageVersionButton;

  /// No description provided for @settingsPageAboutButton.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsPageAboutButton;

  /// No description provided for @scanPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanPageTitle;

  /// No description provided for @scanPageMinDuration.
  ///
  /// In en, this message translates to:
  /// **'Ignore duration less than:'**
  String get scanPageMinDuration;

  /// No description provided for @scanPageDurationUnit.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get scanPageDurationUnit;

  /// No description provided for @scanPageMinSize.
  ///
  /// In en, this message translates to:
  /// **'Ignore size less than:'**
  String get scanPageMinSize;

  /// No description provided for @homePageSongTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get homePageSongTabTitle;

  /// No description provided for @homePagePlaylistTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get homePagePlaylistTabTitle;

  /// No description provided for @homePageArtistsTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get homePageArtistsTabTitle;

  /// No description provided for @songViewSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get songViewSortBy;

  /// No description provided for @songViewOrderBy.
  ///
  /// In en, this message translates to:
  /// **'Order by'**
  String get songViewOrderBy;

  /// No description provided for @songViewToastMessage.
  ///
  /// In en, this message translates to:
  /// **'songs found'**
  String get songViewToastMessage;

  /// No description provided for @songViewSongCount.
  ///
  /// In en, this message translates to:
  /// **'songs'**
  String get songViewSongCount;

  /// No description provided for @aboutPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get aboutPageTitle;

  /// No description provided for @aboutPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We deeply appreciate your support in using this app. It’s users like you who make our work worthwhile. If you’re enjoying the experience and would like to support us further, consider checking out our Patreon page. Your support, no matter how small, helps us improve and bring new features to life!'**
  String get aboutPageSubtitle;

  /// No description provided for @aboutPageQRHint.
  ///
  /// In en, this message translates to:
  /// **'Use this QR code if you have a Vietnamese bank account, Or'**
  String get aboutPageQRHint;

  /// No description provided for @aboutPageEnding.
  ///
  /// In en, this message translates to:
  /// **'Drop me an email if you have any questions or feedback, thank you!'**
  String get aboutPageEnding;

  /// No description provided for @aboutPagePatreonButton.
  ///
  /// In en, this message translates to:
  /// **'Support on Patreon'**
  String get aboutPagePatreonButton;

  /// No description provided for @searchBoxHintText.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchBoxHintText;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
