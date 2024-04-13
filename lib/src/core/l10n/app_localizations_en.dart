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
  String get selectTwoVideosMessage =>
      'Please select at least 2 videos to continue!';

  @override
  String get openPicker => 'Open Picker';

  @override
  String get copyrightMessage => 'Copyright © 2023 BBK Development';

  @override
  String get theme => 'Theme';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get licenses => 'Licenses';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get mainColor => 'Main Color';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get red => 'Red';

  @override
  String get pink => 'Pink';

  @override
  String get purple => 'Purple';

  @override
  String get indigo => 'Indigo';

  @override
  String get blue => 'Blue';

  @override
  String get cyan => 'Cyan';

  @override
  String get teal => 'Teal';

  @override
  String get green => 'Green';

  @override
  String get lime => 'Lime';

  @override
  String get yellow => 'Yellow';

  @override
  String get orange => 'Orange';

  @override
  String get brown => 'Brown';

  @override
  String get settings => 'Settings';

  @override
  String get saveVideo => 'Save Video';

  @override
  String get sound => 'Sound';

  @override
  String get original => 'Original';

  @override
  String get resolution => 'Resolution';

  @override
  String get originalResolutionTooltip =>
      'Videos will keep their original resolution.';

  @override
  String get independentAspectRatioTooltip =>
      'Videos will keep their original aspect ratio.';

  @override
  String get firstAspectRatioTooltip =>
      'Videos will use the aspect ratio of the first video.';

  @override
  String get autoAspectRatioTooltip =>
      'Videos will use the aspect ratio of the selected resolution.';

  @override
  String get independent => 'Independent';

  @override
  String get firstVideo => 'First video';

  @override
  String get auto => 'Auto';

  @override
  String get aspectRatio => 'Aspect Ratio';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get analyzing => 'Analyzing';

  @override
  String get merging => 'Merging';

  @override
  String get saving => 'Saving';

  @override
  String get done => 'Done';

  @override
  String get error => 'Error';

  @override
  String get analyzingMessage =>
      'Analyzing videos to determine the fastest way to merge them. Checking if re-encoding is required...';

  @override
  String get mergingMessage =>
      'Merging videos in a fast and efficient way. This process may take a while so please be patient!';

  @override
  String get savingMessage =>
      'Saving the merged video to your device. Hang tight, this won\'t take long!';

  @override
  String get doneMessage =>
      'The video has been successfully saved to your device!';

  @override
  String get errorMessage =>
      'An error occurred while merging the videos. Please try again!';
}
