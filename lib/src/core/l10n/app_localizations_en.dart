import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'VMerge';

  @override
  String get video => 'Video';

  @override
  String get merge => 'Merge';

  @override
  String get more => 'More';

  @override
  String get selectTwoVideos => 'Please select at least 2 videos to continue!';

  @override
  String get openPicker => 'Open picker';
}
