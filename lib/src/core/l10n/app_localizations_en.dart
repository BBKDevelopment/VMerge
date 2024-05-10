import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get analyzing => 'Analyzing';

  @override
  String get analyzingMessage =>
      'Analyzing videos to determine the fastest way to merge them. Checking if re-encoding is required...';

  @override
  String get appName => 'VMerge';

  @override
  String get aspectRatio => 'Aspect Ratio';

  @override
  String get auto => 'Auto';

  @override
  String get autoAspectRatioTooltip =>
      'Videos will use the aspect ratio of the selected resolution.';

  @override
  String get blue => 'Blue';

  @override
  String get brown => 'Brown';

  @override
  String get cancel => 'Cancel';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get cancelledMessage => 'The video merge process has been cancelled!';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get copyrightMessage => 'Copyright © 2024 BBK Development';

  @override
  String get couldNotChangeVolumeMessage =>
      'Could not change the volume of the video! Please try again later.';

  @override
  String get couldNotInitVideoPlayerMessage =>
      'Could not initialize video player! Please confirm that video files are valid.';

  @override
  String get couldNotLoadVideosMessage =>
      'Could not load videos! Please confirm that video files are valid.';

  @override
  String get couldNotOpenAssetPickerMessage =>
      'Could not open the asset picker! Please grant the necessary permissions.';

  @override
  String get couldNotOpenPrivacyPolicyMessage =>
      'Could not open privacy policy! Please check your internet connection and try again.';

  @override
  String get couldNotOpenTermsAndConditionsMessage =>
      'Could not open terms and conditions! Please check your internet connection and try again.';

  @override
  String get couldNotPauseVideoMessage =>
      'Could not pause video! Please try again later.';

  @override
  String get couldNotPlayVideoMessage =>
      'Could not play video! Please confirm that video files are valid.';

  @override
  String get couldNotLaunchEmailServiceMessage =>
      'Could not launch email service! Please check your internet connection and try again.';

  @override
  String get couldNotLaunchReviewServiceMessage =>
      'Could not launch review service! Please check your internet connection and try again.';

  @override
  String get couldNotSeekVideoPositionMessage =>
      'Could not seek video position! Please try again later.';

  @override
  String get couldNotSetVideoSpeedMessage =>
      'Could not set video playback speed! Please try again later.';

  @override
  String get cyan => 'Cyan';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get discardChanges => 'Discard changes';

  @override
  String get done => 'Done';

  @override
  String get doneMessage =>
      'The video has been successfully saved to your device!';

  @override
  String get exceptionDetail => 'Exception Detail';

  @override
  String get error => 'Error';

  @override
  String get errorMessage =>
      'An error occurred while merging the videos. Please try again!';

  @override
  String get failedToInitFFmpegMessage =>
      'Failed to initialise FFmpeg! Please try again later.';

  @override
  String get failedToLaunchGalleryMessage =>
      'Failed to launch gallery! Please grant the required permissions.';

  @override
  String get failedToMergeVideosMessage =>
      'Failed to merge videos! Please try with different configurations.';

  @override
  String get failedToSaveVideoMessage =>
      'Failed to save merged video! Please grant the required permissions.';

  @override
  String get firstAspectRatioTooltip =>
      'Videos will use the aspect ratio of the first video.';

  @override
  String get firstVideo => 'First video';

  @override
  String get green => 'Green';

  @override
  String get independent => 'Independent';

  @override
  String get independentAspectRatioTooltip =>
      'Videos will keep their original aspect ratio.';

  @override
  String get indigo => 'Indigo';

  @override
  String get leave => 'Leave';

  @override
  String get licenses => 'Licenses';

  @override
  String get lime => 'Lime';

  @override
  String get mainColor => 'Main Color';

  @override
  String get merge => 'Merge';

  @override
  String get merging => 'Merging';

  @override
  String get mergingMessage =>
      'Merging videos in a fast and efficient way. This process may take a while so please be patient!';

  @override
  String get more => 'More';

  @override
  String get no => 'No';

  @override
  String get off => 'Off';

  @override
  String get on => 'On';

  @override
  String get openPicker => 'Open Picker';

  @override
  String get orange => 'Orange';

  @override
  String get original => 'Original';

  @override
  String get originalResolutionTooltip =>
      'Videos will keep their original resolution.';

  @override
  String get permissionDeniedMessage =>
      'Permission denied! Please grant the required permissions.';

  @override
  String get pink => 'Pink';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get playbackSpeedWarningMessage =>
      'Setting a custom playback speed will force re-encoding during the merge process and may take longer to complete.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get purple => 'Purple';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get red => 'Red';

  @override
  String get resolution => 'Resolution';

  @override
  String get resolutionWarningMessage =>
      'Setting a custom resolution will force re-encoding during the merge process and may take longer to complete.';

  @override
  String get saveCancellationConfirmMessage =>
      'Are you sure you want to cancel the video merging process? Any progress will be lost.';

  @override
  String get saveVideo => 'Save Video';

  @override
  String get saving => 'Saving';

  @override
  String get savingMessage =>
      'Saving the merged video to your device. Hang tight, this won\'t take long!';

  @override
  String get seeInTheGallery => 'See in the Gallery';

  @override
  String get selectTwoVideosMessage =>
      'Please select at least 2 videos to continue!';

  @override
  String get settings => 'Settings';

  @override
  String get sound => 'Sound';

  @override
  String get teal => 'Teal';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get theme => 'Theme';

  @override
  String get twoVideosRequiredMessage =>
      'At least two videos are required to merge!';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved changes. Are you sure you want to leave this page?';

  @override
  String get video => 'Video';

  @override
  String get warning => 'Warning';

  @override
  String get yellow => 'Yellow';

  @override
  String get yes => 'Yes';
}
