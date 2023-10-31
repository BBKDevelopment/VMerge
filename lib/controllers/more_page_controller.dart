// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vmerge/models/models.dart';
import 'package:vmerge/services/abstracts/launcer_service.dart';
import 'package:vmerge/services/concretes/launcher_adapter.dart';
import 'package:vmerge/utilities/utilities.dart';

class MorePageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final LauncerService _launcerService;
  late final PackageInfo _packageInfo;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late final List<MoreItem> _moreItemList;
  late final List<double> _beginList;
  late final List<double> _endList;

  AnimationController get getAnimationController => _animationController;
  Animation<double> get getAnimation => _animation;
  List<MoreItem> get getMoreItemList => _moreItemList;
  List<double> get getBeginList => _beginList;
  List<double> get getEndList => _endList;

  @override
  void onInit() {
    super.onInit();
    _moreItemList = <MoreItem>[];
    _beginList = <double>[];
    _endList = <double>[];
    _launcerService = LauncherAdapter();
    _animationController = AnimationController(
      vsync: this,
      duration: kMorePageInAnimationDuration,
    );
    _animation = Tween(begin: 0.toDouble(), end: 1.toDouble())
        .animate(_animationController);
    _getPackageInfo();
    _createItemsForMorePage();
  }

  @override
  void onClose() {
    _moreItemList.clear();
    _animationController.dispose();
    super.onClose();
  }

  void _createItemsForMorePage() {
    _moreItemList.add(MoreItem(kStarIconPath, kRateText));
    _moreItemList.add(MoreItem(kMailIconPath, kContactsText));
    _moreItemList.add(MoreItem(kTermsIconPath, kTermsText));
    _moreItemList.add(MoreItem(kPrivacyIconPath, kPrivacyText));
    _moreItemList.add(MoreItem(kLicenseIconPath, kLicenseText));
  }

  Future<void> _getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  void setStaggeredAnimation(int index) {
    _beginList.add(index / getMoreItemList.length / 2);
    _endList.add((index + 1) / getMoreItemList.length / 2);
  }

  Future<void> onTappedItem(int item) async {
    switch (item) {
      case 0:
        await LaunchReview.launch(androidAppId: kAndroidAppId);
      case 1:
        await _launcerService.sendMail();
      case 2:
        await _launcerService.launchUrl(kTermsAndConditions);
      case 3:
        await _launcerService.launchUrl(kPrivacyPolicy);
      case 4:
        showLicensePage(
          context: Get.context!,
          applicationName: kAppName,
          applicationIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SvgPicture.asset(kAppLogoPath, height: kIconSize * 4),
          ),
          applicationVersion: _packageInfo.version,
          applicationLegalese: kCopyrightText,
        );
    }
  }
}
