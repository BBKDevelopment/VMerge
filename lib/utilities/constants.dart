// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

//configs
const String kAndroidAppId = 'com.BBKDevelopment.VMerge';

//texts
const String kAppName = 'VMerge';
const String kSelectVideoText =
    'Select the videos you want to merge before continuing.\n\nWhen videos are selected successfully, they will be listed below.';
const String kRateText = 'Rate Us';
const String kContactsText = 'Contact Us';
const String kTermsText = 'Terms and Conditions';
const String kPrivacyText = 'Privacy Policy';
const String kLicenseText = 'Licenses';
const String kCopyrightText = 'Copyright © 2022 BBK Development';
const String kSettingsText = 'Settings';
const String kVideoSoundText = 'Video Sound:';
const String kVideoSpeedText = 'Video Speed:';
const String kVideoQualityText = 'Output Video Quality:';
const String kSaveToAlbumText = 'Save to Album';
const String kWaitText = 'Please wait until the process finishes.';
const String kMergeText = 'Merging videos, please wait.';
const String kCompressText = 'Compressing the video, please wait.';
const String kSuccessText = 'Video successfully saved to the gallery.';
const String kNoticeText =
    'Sound will be set to off if you change video speed!';

//links
const String kBBKDevelopmentOfficial = 'https://www.bbkdevelopment.com';
const String kPrivacyPolicy =
    'https://www.bbkdevelopment.com/bbk-development/vmerge/privacy-policy';
const String kTermsAndConditions =
    'https://www.bbkdevelopment.com/bbk-development/vmerge/terms-and-conditions';

//colors
const Color kPrimaryColor = Color(0xff1F1B24);
const Color kPrimaryColorDark = Color(0xff141414);
const Color kPrimaryWhiteColor = Color(0xffF8F3F7);
const Color kTimelineControllerColor = Color(0xff4C454C);

//assets
const String kAppLogoPath = 'assets/images/application_logo.svg';
const String kMiniLogoIconPath = 'assets/images/mini_logo.svg';
const String kHomeIconPath = 'assets/images/home.svg';
const String kCutIconPath = 'assets/images/cut.svg';
const String kMoreIconPath = 'assets/images/more.svg';
const String kCameraIconPath = 'assets/images/camera.svg';
const String kSettingIconPath = 'assets/images/setting.svg';
const String kSaveIconPath = 'assets/images/save.svg';
const String kPlayIconPath = 'assets/images/play.svg';
const String kStarIconPath = 'assets/images/star.svg';
const String kMailIconPath = 'assets/images/mail.svg';
const String kTermsIconPath = 'assets/images/terms.svg';
const String kPrivacyIconPath = 'assets/images/privacy.svg';
const String kLicenseIconPath = 'assets/images/license.svg';
const String kBBKLogoIconPath = 'assets/images/bbk_logo.png';
const String kCloseIconPath = 'assets/images/close.svg';
const String kErrorIconPath = 'assets/images/error.svg';

//values
const double kIconSize = 28;
const double kVideoItemAspectRatio = 2 / 3;
const double kSoundItemAspectRatio = 1 / 2;
const double kGridViewItemsBorderRadius = 2;
const double kVerticalVideoBorderRadius = 8;
const double kGeneralBorderRadius = 2;

//animation durations
const Duration kEditPageInAnimationDuration = Duration(milliseconds: 1000);
const Duration kEditPageOutAnimationDuration = Duration(milliseconds: 300);
const Duration kMorePageInAnimationDuration = Duration(milliseconds: 1000);
const Duration kMorePageOutAnimationDuration = Duration(milliseconds: 300);

//styles
const TextStyle kBoldTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: kPrimaryWhiteColor,
);
const TextStyle kSemiBoldTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: kPrimaryWhiteColor,
);
const TextStyle kMediumTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: kPrimaryWhiteColor,
);
const TextStyle kRegularTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: kPrimaryWhiteColor,
);
const TextStyle kSmallTextStyle = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w700,
  color: kPrimaryWhiteColor,
);
const TextStyle kSmallLightTextStyle = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w400,
  color: kPrimaryWhiteColor,
);
