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
  String get couldNotOpenStoreListingMessage =>
      'Could not open store listing! Please check your internet connection and try again.';

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
  String get faq => 'FAQ';

  @override
  String get faqQuestion1 => 'Why does my video merging take too long?';

  @override
  String get faqAnswer1 =>
      'When video specs are different from each other, re-encoding is applied to ensure that the output video will work on every video player without any problems. This process may take a bit longer based on the video length and the CPU capability of your device.';

  @override
  String get faqQuestion2 => 'Can I merge videos without re-encoding?';

  @override
  String get faqAnswer2 =>
      'If the video specs are identical, the app can merge them without re-encoding, saving time and preserving quality.';

  @override
  String get faqQuestion3 => 'How do I add videos for merging?';

  @override
  String get faqAnswer3 =>
      'Tap the \"Video\" option on the navigation bar to open the video picker, then select up to four videos.';

  @override
  String get faqQuestion4 => 'How many videos can I merge at the same time?';

  @override
  String get faqAnswer4 => 'You can merge up to four videos at a time.';

  @override
  String get faqQuestion5 => 'How can I order the videos for merging?';

  @override
  String get faqAnswer5 =>
      'Select the videos in the order you want them merged when using the video picker.';

  @override
  String get faqQuestion6 =>
      'Can I change the order of the videos before merging?';

  @override
  String get faqAnswer6 =>
      'No, you must select the videos in the desired order when using the video picker.';

  @override
  String get faqQuestion7 => 'How do I delete a video from the merge list?';

  @override
  String get faqAnswer7 =>
      'It is not possible to edit merge list after selection, to modify the list you should tap videos on the navigation bar to open video picker and recreate the list.';

  @override
  String get faqQuestion8 => 'How do I save the merged video?';

  @override
  String get faqAnswer8 =>
      'After tapping the save button, the videos will be merged and automatically saved to your gallery.';

  @override
  String get faqQuestion9 => 'Can I preview the merged video before saving?';

  @override
  String get faqAnswer9 =>
      'Yes, the video in the merge section serves as a preview of the final output.';

  @override
  String get faqQuestion10 =>
      'How do I export the merged video to social media?';

  @override
  String get faqAnswer10 =>
      'After merging, the output video will be automatically saved to your gallery. From there, you can directly upload it to your social media accounts.';

  @override
  String get faqQuestion11 => 'Can I trim videos before merging them?';

  @override
  String get faqAnswer11 =>
      'Yes and no. You can use our other app, VClip, to trim videos by selecting the start and end points. This way, you can trim each video before merging them in this app.';

  @override
  String get faqQuestion12 => 'How do I adjust the output video resolution?';

  @override
  String get faqAnswer12 =>
      'Go to the settings menu and select the desired resolution for the output video before starting the merge process.';

  @override
  String get faqQuestion13 => 'Can I merge videos of different resolutions?';

  @override
  String get faqAnswer13 =>
      'Yes, you can merge videos of different resolutions. The app will adjust them to the resolution as set in the settings.';

  @override
  String get faqQuestion14 =>
      'Can I merge videos with different aspect ratios?';

  @override
  String get faqAnswer14 =>
      'Yes, the app will adjust the aspect ratios based on the configuration that is set.';

  @override
  String get faqQuestion15 => 'Can I merge videos with different frame rates?';

  @override
  String get faqAnswer15 =>
      'Yes, the app can handle videos with different frame rates and will adjust them during the merging process.';

  @override
  String get faqQuestion16 => 'Can I merge videos with different codecs?';

  @override
  String get faqAnswer16 =>
      'Yes, the app supports multiple codecs and will re-encode as necessary to ensure compatibility.';

  @override
  String get faqQuestion17 =>
      'Can I merge videos with different audio formats?';

  @override
  String get faqAnswer17 =>
      'Yes, the app will standardize the audio formats during the merging process.';

  @override
  String get faqQuestion18 => 'Can I merge videos without audio?';

  @override
  String get faqAnswer18 =>
      'Yes, you can mute the audio tracks before merging if you prefer a silent video. To do this, open the settings menu and set the sound option to off.';

  @override
  String get faqQuestion19 => 'Can I merge videos with subtitles?';

  @override
  String get faqAnswer19 =>
      'Yes, the app supports merging videos with embedded subtitles. However, external subtitle files are not supported at this time.';

  @override
  String get faqQuestion20 => 'Does the app support 4K videos?';

  @override
  String get faqAnswer20 =>
      'Yes, the app supports 4K video merging, provided your device has the necessary resources to handle high-resolution files.';

  @override
  String get faqQuestion21 =>
      'What is the maximum file size supported for merging?';

  @override
  String get faqAnswer21 =>
      'The app can handle large files, but the maximum supported size depends on your device’s capabilities.';

  @override
  String get faqQuestion22 => 'What do I do if the app is running slowly?';

  @override
  String get faqAnswer22 =>
      'Close other applications to free up system resources, and check for any available updates for the app.';

  @override
  String get faqQuestion23 =>
      'Why is my device overheating during the merge process?';

  @override
  String get faqAnswer23 =>
      'Video merging is resource-intensive and may cause your device to heat up. Ensure your device has proper ventilation and consider merging fewer videos at a time.';

  @override
  String get faqQuestion24 => 'Why does the app crash during merging?';

  @override
  String get faqAnswer24 =>
      'This is likely due to a memory-related issue that can occur on devices with low memory.';

  @override
  String get faqQuestion25 =>
      'What should I do if the app crashes during merging?';

  @override
  String get faqAnswer25 =>
      'Ensure you have sufficient free space. Restart the app and try with fewer videos. If the problem persists, contact support.';

  @override
  String get faqQuestion26 => 'Why does the merged video file size seem large?';

  @override
  String get faqAnswer26 =>
      'The file size depends on the resolution, bitrate, and length of the merged video.';

  @override
  String get faqQuestion27 => 'Why is the video quality reduced after merging?';

  @override
  String get faqAnswer27 =>
      'Ensure you are using the highest quality settings. Some loss of quality may occur due to compression and encoding.';

  @override
  String get faqQuestion28 =>
      'What should I do if the merged video has no sound?';

  @override
  String get faqAnswer28 =>
      'Check the sound settings and ensure that the source videos have working audio tracks.';

  @override
  String get faqQuestion29 =>
      'Is there a way to automatically sync audio and video?';

  @override
  String get faqAnswer29 =>
      'The app includes an automatic sync feature that aligns audio and video tracks during the merging process.';

  @override
  String get faqQuestion30 =>
      'Why does the app require access to my media files?';

  @override
  String get faqAnswer30 =>
      'The app needs access to your media files to select, process, and save videos during the merge process.';

  @override
  String get faqQuestion31 => 'How do I change the theme of the app?';

  @override
  String get faqAnswer31 =>
      'Go to the theme menu and select your preferred theme from the available options.';

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
