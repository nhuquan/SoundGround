import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'SoundGround';

  @override
  String get themePageTitle => 'Màu sắc';

  @override
  String get settingsPageTitle => 'Cài đặt';

  @override
  String get settingsPageScanMusicButton => 'Tìm kiếm bài hát';

  @override
  String get settingsPageScanMusicButtonSubtitle => 'Bỏ qua bài hát không đáp ứng yêu cầu';

  @override
  String get settingsPageLanguageButton => 'Ngôn ngữ';

  @override
  String get settingsPageVersionButton => 'Phiên bản';

  @override
  String get settingsPageAboutButton => 'Tác giả';

  @override
  String get scanPageTitle => 'Tìm kiếm bài hát';

  @override
  String get scanPageMinDuration => 'Thời lượng tối thiểu:';

  @override
  String get scanPageDurationUnit => 'giây';

  @override
  String get scanPageMinSize => 'Dung lượng tối thiểu:';

  @override
  String get homePageSongTabTitle => 'Bài hát';

  @override
  String get homePagePlaylistTabTitle => 'Danh sách';

  @override
  String get homePageArtistsTabTitle => 'Ca sĩ';

  @override
  String get songViewSortBy => 'Xếp theo';

  @override
  String get songViewOrderBy => 'Thứ tự';

  @override
  String get songViewToastMessage => 'bài hát được tìm thấy';

  @override
  String get songViewSongCount => 'bài hát';

  @override
  String get aboutPageTitle => 'Cảm ơn bạn rất nhiều!';

  @override
  String get aboutPageSubtitle => 'Mình chỉ là một anh kỹ sư thích tự code và phát triển sản phẩm để giải quyết những vấn đề của bản thân. Nếu bạn thích ứng dụng này, hãy ủng hộ mình nhé!';

  @override
  String get aboutPageQRHint => 'Hỗ trơ trực tiếp cho mình qua QRCode này hoặc là qua';

  @override
  String get aboutPageEnding => 'Gửi email cho mình nhé!';

  @override
  String get aboutPagePatreonButton => 'Patreon';

  @override
  String get searchBoxHintText => 'Tìm kiếm theo tên bài hát';
}
