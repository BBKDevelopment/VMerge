import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing'**
  String get analyzing;

  /// No description provided for @analyzingMessage.
  ///
  /// In en, this message translates to:
  /// **'Analyzing videos to determine the fastest way to merge them. Checking if re-encoding is required...'**
  String get analyzingMessage;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'VMerge'**
  String get appName;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @autoAspectRatioTooltip.
  ///
  /// In en, this message translates to:
  /// **'Videos will use the aspect ratio of the selected resolution.'**
  String get autoAspectRatioTooltip;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @brown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get brown;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @cancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'The video merge process has been cancelled!'**
  String get cancelledMessage;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @copyrightMessage.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2024 BBK Development'**
  String get copyrightMessage;

  /// No description provided for @couldNotChangeVolumeMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not change the volume of the video! Please try again later.'**
  String get couldNotChangeVolumeMessage;

  /// No description provided for @couldNotInitVideoPlayerMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not initialize video player! Please confirm that video files are valid.'**
  String get couldNotInitVideoPlayerMessage;

  /// No description provided for @couldNotLoadVideosMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not load videos! Please confirm that video files are valid.'**
  String get couldNotLoadVideosMessage;

  /// No description provided for @couldNotOpenAssetPickerMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not open the asset picker! Please grant the necessary permissions.'**
  String get couldNotOpenAssetPickerMessage;

  /// No description provided for @couldNotOpenPrivacyPolicyMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not open privacy policy! Please check your internet connection and try again.'**
  String get couldNotOpenPrivacyPolicyMessage;

  /// No description provided for @couldNotOpenStoreListingMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not open store listing! Please check your internet connection and try again.'**
  String get couldNotOpenStoreListingMessage;

  /// No description provided for @couldNotOpenTermsAndConditionsMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not open terms and conditions! Please check your internet connection and try again.'**
  String get couldNotOpenTermsAndConditionsMessage;

  /// No description provided for @couldNotPauseVideoMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not pause video! Please try again later.'**
  String get couldNotPauseVideoMessage;

  /// No description provided for @couldNotPlayVideoMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not play video! Please confirm that video files are valid.'**
  String get couldNotPlayVideoMessage;

  /// No description provided for @couldNotLaunchEmailServiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not launch email service! Please check your internet connection and try again.'**
  String get couldNotLaunchEmailServiceMessage;

  /// No description provided for @couldNotSeekVideoPositionMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not seek video position! Please try again later.'**
  String get couldNotSeekVideoPositionMessage;

  /// No description provided for @couldNotSetVideoSpeedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not set video playback speed! Please try again later.'**
  String get couldNotSetVideoSpeedMessage;

  /// No description provided for @cyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get cyan;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get discardChanges;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @doneMessage.
  ///
  /// In en, this message translates to:
  /// **'The video has been successfully saved to your device!'**
  String get doneMessage;

  /// No description provided for @exceptionDetail.
  ///
  /// In en, this message translates to:
  /// **'Exception Detail'**
  String get exceptionDetail;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while merging the videos. Please try again!'**
  String get errorMessage;

  /// No description provided for @failedToInitFFmpegMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialise FFmpeg! Please try again later.'**
  String get failedToInitFFmpegMessage;

  /// No description provided for @failedToLaunchGalleryMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to launch gallery! Please grant the required permissions.'**
  String get failedToLaunchGalleryMessage;

  /// No description provided for @failedToMergeVideosMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to merge videos! Please try with different configurations.'**
  String get failedToMergeVideosMessage;

  /// No description provided for @failedToSaveVideoMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save merged video! Please grant the required permissions.'**
  String get failedToSaveVideoMessage;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'Why does my video merging take too long?'**
  String get faqQuestion1;

  /// No description provided for @faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'When video specs are different from each other, re-encoding is applied to ensure that the output video will work on every video player without any problems. This process may take a bit longer based on the video length and the CPU capability of your device.'**
  String get faqAnswer1;

  /// No description provided for @faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'Can I merge videos without re-encoding?'**
  String get faqQuestion2;

  /// No description provided for @faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'If the video specs are identical, the app can merge them without re-encoding, saving time and preserving quality.'**
  String get faqAnswer2;

  /// No description provided for @faqQuestion3.
  ///
  /// In en, this message translates to:
  /// **'How do I add videos for merging?'**
  String get faqQuestion3;

  /// No description provided for @faqAnswer3.
  ///
  /// In en, this message translates to:
  /// **'Tap the \"Video\" option on the navigation bar to open the video picker, then select up to four videos.'**
  String get faqAnswer3;

  /// No description provided for @faqQuestion4.
  ///
  /// In en, this message translates to:
  /// **'How many videos can I merge at the same time?'**
  String get faqQuestion4;

  /// No description provided for @faqAnswer4.
  ///
  /// In en, this message translates to:
  /// **'You can merge up to four videos at a time.'**
  String get faqAnswer4;

  /// No description provided for @faqQuestion5.
  ///
  /// In en, this message translates to:
  /// **'How can I order the videos for merging?'**
  String get faqQuestion5;

  /// No description provided for @faqAnswer5.
  ///
  /// In en, this message translates to:
  /// **'Select the videos in the order you want them merged when using the video picker.'**
  String get faqAnswer5;

  /// No description provided for @faqQuestion6.
  ///
  /// In en, this message translates to:
  /// **'Can I change the order of the videos before merging?'**
  String get faqQuestion6;

  /// No description provided for @faqAnswer6.
  ///
  /// In en, this message translates to:
  /// **'No, you must select the videos in the desired order when using the video picker.'**
  String get faqAnswer6;

  /// No description provided for @faqQuestion7.
  ///
  /// In en, this message translates to:
  /// **'How do I delete a video from the merge list?'**
  String get faqQuestion7;

  /// No description provided for @faqAnswer7.
  ///
  /// In en, this message translates to:
  /// **'It is not possible to edit merge list after selection, to modify the list you should tap videos on the navigation bar to open video picker and recreate the list.'**
  String get faqAnswer7;

  /// No description provided for @faqQuestion8.
  ///
  /// In en, this message translates to:
  /// **'How do I save the merged video?'**
  String get faqQuestion8;

  /// No description provided for @faqAnswer8.
  ///
  /// In en, this message translates to:
  /// **'After tapping the save button, the videos will be merged and automatically saved to your gallery.'**
  String get faqAnswer8;

  /// No description provided for @faqQuestion9.
  ///
  /// In en, this message translates to:
  /// **'Can I preview the merged video before saving?'**
  String get faqQuestion9;

  /// No description provided for @faqAnswer9.
  ///
  /// In en, this message translates to:
  /// **'Yes, the video in the merge section serves as a preview of the final output.'**
  String get faqAnswer9;

  /// No description provided for @faqQuestion10.
  ///
  /// In en, this message translates to:
  /// **'How do I export the merged video to social media?'**
  String get faqQuestion10;

  /// No description provided for @faqAnswer10.
  ///
  /// In en, this message translates to:
  /// **'After merging, the output video will be automatically saved to your gallery. From there, you can directly upload it to your social media accounts.'**
  String get faqAnswer10;

  /// No description provided for @faqQuestion11.
  ///
  /// In en, this message translates to:
  /// **'Can I trim videos before merging them?'**
  String get faqQuestion11;

  /// No description provided for @faqAnswer11.
  ///
  /// In en, this message translates to:
  /// **'Yes and no. You can use our other app, VClip, to trim videos by selecting the start and end points. This way, you can trim each video before merging them in this app.'**
  String get faqAnswer11;

  /// No description provided for @faqQuestion12.
  ///
  /// In en, this message translates to:
  /// **'How do I adjust the output video resolution?'**
  String get faqQuestion12;

  /// No description provided for @faqAnswer12.
  ///
  /// In en, this message translates to:
  /// **'Go to the settings menu and select the desired resolution for the output video before starting the merge process.'**
  String get faqAnswer12;

  /// No description provided for @faqQuestion13.
  ///
  /// In en, this message translates to:
  /// **'Can I merge videos of different resolutions?'**
  String get faqQuestion13;

  /// No description provided for @faqAnswer13.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can merge videos of different resolutions. The app will adjust them to the resolution as set in the settings.'**
  String get faqAnswer13;

  /// No description provided for @faqQuestion14.
  ///
  /// In en, this message translates to:
  /// **'Can I merge videos with different aspect ratios?'**
  String get faqQuestion14;

  /// No description provided for @faqAnswer14.
  ///
  /// In en, this message translates to:
  /// **'Yes, the app will adjust the aspect ratios based on the configuration that is set.'**
  String get faqAnswer14;

  /// No description provided for @faqQuestion15.
  ///
  /// In en, this message translates to:
  /// **'Can I merge videos with different frame rates?'**
  String get faqQuestion15;

  /// No description provided for @faqAnswer15.
  ///
  /// In en, this message translates to:
  /// **'Yes, the app can handle videos with different frame rates and will adjust them during the merging process.'**
  String get faqAnswer15;

  /// No description provided for @faqQuestion16.
  ///
  /// In en, this message translates to:
  /// **'Can I merge videos with different codecs?'**
  String get faqQuestion16;

  /// No description provided for @faqAnswer16.
  ///
  /// In en, this message translates to:
  /// **'Yes, the app supports multiple codecs and will re-encode as necessary to ensure compatibility.'**
  String get faqAnswer16;

  /// No description provided for @faqQuestion17.
  ///
  /// In en, this message translates to:
  /// **'Can I merge videos with different audio formats?'**
  String get faqQuestion17;

  /// No description provided for @faqAnswer17.
  ///
  /// In en, this message translates to:
  /// **'Yes, the app will standardize the audio formats during the merging process.'**
  String get faqAnswer17;

  /// No description provided for @faqQuestion18.
  ///
  /// In en, this message translates to:
  /// **'Can I merge videos without audio?'**
  String get faqQuestion18;

  /// No description provided for @faqAnswer18.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can mute the audio tracks before merging if you prefer a silent video. To do this, open the settings menu and set the sound option to off.'**
  String get faqAnswer18;

  /// No description provided for @faqQuestion19.
  ///
  /// In en, this message translates to:
  /// **'Can I merge videos with subtitles?'**
  String get faqQuestion19;

  /// No description provided for @faqAnswer19.
  ///
  /// In en, this message translates to:
  /// **'Yes, the app supports merging videos with embedded subtitles. However, external subtitle files are not supported at this time.'**
  String get faqAnswer19;

  /// No description provided for @faqQuestion20.
  ///
  /// In en, this message translates to:
  /// **'Does the app support 4K videos?'**
  String get faqQuestion20;

  /// No description provided for @faqAnswer20.
  ///
  /// In en, this message translates to:
  /// **'Yes, the app supports 4K video merging, provided your device has the necessary resources to handle high-resolution files.'**
  String get faqAnswer20;

  /// No description provided for @faqQuestion21.
  ///
  /// In en, this message translates to:
  /// **'What is the maximum file size supported for merging?'**
  String get faqQuestion21;

  /// No description provided for @faqAnswer21.
  ///
  /// In en, this message translates to:
  /// **'The app can handle large files, but the maximum supported size depends on your device’s capabilities.'**
  String get faqAnswer21;

  /// No description provided for @faqQuestion22.
  ///
  /// In en, this message translates to:
  /// **'What do I do if the app is running slowly?'**
  String get faqQuestion22;

  /// No description provided for @faqAnswer22.
  ///
  /// In en, this message translates to:
  /// **'Close other applications to free up system resources, and check for any available updates for the app.'**
  String get faqAnswer22;

  /// No description provided for @faqQuestion23.
  ///
  /// In en, this message translates to:
  /// **'Why is my device overheating during the merge process?'**
  String get faqQuestion23;

  /// No description provided for @faqAnswer23.
  ///
  /// In en, this message translates to:
  /// **'Video merging is resource-intensive and may cause your device to heat up. Ensure your device has proper ventilation and consider merging fewer videos at a time.'**
  String get faqAnswer23;

  /// No description provided for @faqQuestion24.
  ///
  /// In en, this message translates to:
  /// **'Why does the app crash during merging?'**
  String get faqQuestion24;

  /// No description provided for @faqAnswer24.
  ///
  /// In en, this message translates to:
  /// **'This is likely due to a memory-related issue that can occur on devices with low memory.'**
  String get faqAnswer24;

  /// No description provided for @faqQuestion25.
  ///
  /// In en, this message translates to:
  /// **'What should I do if the app crashes during merging?'**
  String get faqQuestion25;

  /// No description provided for @faqAnswer25.
  ///
  /// In en, this message translates to:
  /// **'Ensure you have sufficient free space. Restart the app and try with fewer videos. If the problem persists, contact support.'**
  String get faqAnswer25;

  /// No description provided for @faqQuestion26.
  ///
  /// In en, this message translates to:
  /// **'Why does the merged video file size seem large?'**
  String get faqQuestion26;

  /// No description provided for @faqAnswer26.
  ///
  /// In en, this message translates to:
  /// **'The file size depends on the resolution, bitrate, and length of the merged video.'**
  String get faqAnswer26;

  /// No description provided for @faqQuestion27.
  ///
  /// In en, this message translates to:
  /// **'Why is the video quality reduced after merging?'**
  String get faqQuestion27;

  /// No description provided for @faqAnswer27.
  ///
  /// In en, this message translates to:
  /// **'Ensure you are using the highest quality settings. Some loss of quality may occur due to compression and encoding.'**
  String get faqAnswer27;

  /// No description provided for @faqQuestion28.
  ///
  /// In en, this message translates to:
  /// **'What should I do if the merged video has no sound?'**
  String get faqQuestion28;

  /// No description provided for @faqAnswer28.
  ///
  /// In en, this message translates to:
  /// **'Check the sound settings and ensure that the source videos have working audio tracks.'**
  String get faqAnswer28;

  /// No description provided for @faqQuestion29.
  ///
  /// In en, this message translates to:
  /// **'Is there a way to automatically sync audio and video?'**
  String get faqQuestion29;

  /// No description provided for @faqAnswer29.
  ///
  /// In en, this message translates to:
  /// **'The app includes an automatic sync feature that aligns audio and video tracks during the merging process.'**
  String get faqAnswer29;

  /// No description provided for @faqQuestion30.
  ///
  /// In en, this message translates to:
  /// **'Why does the app require access to my media files?'**
  String get faqQuestion30;

  /// No description provided for @faqAnswer30.
  ///
  /// In en, this message translates to:
  /// **'The app needs access to your media files to select, process, and save videos during the merge process.'**
  String get faqAnswer30;

  /// No description provided for @faqQuestion31.
  ///
  /// In en, this message translates to:
  /// **'How do I change the theme of the app?'**
  String get faqQuestion31;

  /// No description provided for @faqAnswer31.
  ///
  /// In en, this message translates to:
  /// **'Go to the theme menu and select your preferred theme from the available options.'**
  String get faqAnswer31;

  /// No description provided for @firstAspectRatioTooltip.
  ///
  /// In en, this message translates to:
  /// **'Videos will use the aspect ratio of the first video.'**
  String get firstAspectRatioTooltip;

  /// No description provided for @firstVideo.
  ///
  /// In en, this message translates to:
  /// **'First video'**
  String get firstVideo;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// No description provided for @independent.
  ///
  /// In en, this message translates to:
  /// **'Independent'**
  String get independent;

  /// No description provided for @independentAspectRatioTooltip.
  ///
  /// In en, this message translates to:
  /// **'Videos will keep their original aspect ratio.'**
  String get independentAspectRatioTooltip;

  /// No description provided for @indigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get indigo;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @lime.
  ///
  /// In en, this message translates to:
  /// **'Lime'**
  String get lime;

  /// No description provided for @mainColor.
  ///
  /// In en, this message translates to:
  /// **'Main Color'**
  String get mainColor;

  /// No description provided for @merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// No description provided for @merging.
  ///
  /// In en, this message translates to:
  /// **'Merging'**
  String get merging;

  /// No description provided for @mergingMessage.
  ///
  /// In en, this message translates to:
  /// **'Merging videos in a fast and efficient way. This process may take a while so please be patient!'**
  String get mergingMessage;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @openPicker.
  ///
  /// In en, this message translates to:
  /// **'Open Picker'**
  String get openPicker;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @originalResolutionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Videos will keep their original resolution.'**
  String get originalResolutionTooltip;

  /// No description provided for @permissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Permission denied! Please grant the required permissions.'**
  String get permissionDeniedMessage;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playbackSpeed;

  /// No description provided for @playbackSpeedWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'Setting a custom playback speed will force re-encoding during the merge process and may take longer to complete.'**
  String get playbackSpeedWarningMessage;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @resolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get resolution;

  /// No description provided for @resolutionWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'Setting a custom resolution will force re-encoding during the merge process and may take longer to complete.'**
  String get resolutionWarningMessage;

  /// No description provided for @saveCancellationConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the video merging process? Any progress will be lost.'**
  String get saveCancellationConfirmMessage;

  /// No description provided for @saveVideo.
  ///
  /// In en, this message translates to:
  /// **'Save Video'**
  String get saveVideo;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get saving;

  /// No description provided for @savingMessage.
  ///
  /// In en, this message translates to:
  /// **'Saving the merged video to your device. Hang tight, this won\'t take long!'**
  String get savingMessage;

  /// No description provided for @seeInTheGallery.
  ///
  /// In en, this message translates to:
  /// **'See in the Gallery'**
  String get seeInTheGallery;

  /// No description provided for @selectTwoVideosMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select at least 2 videos to continue!'**
  String get selectTwoVideosMessage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @teal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get teal;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @twoVideosRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'At least two videos are required to merge!'**
  String get twoVideosRequiredMessage;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave this page?'**
  String get unsavedChangesMessage;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get yellow;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
