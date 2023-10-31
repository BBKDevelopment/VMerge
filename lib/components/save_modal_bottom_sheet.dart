// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vmerge/controllers/controllers.dart';
import 'package:vmerge/utilities/utilities.dart';

class SaveModalBottomSheet extends StatelessWidget {
  SaveModalBottomSheet({super.key}) {
    _editPageController = Get.find();
  }

  late final EditPageController _editPageController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: kIconSize),
                  const Text(
                    kSaveToAlbumText,
                    style: kBoldTextStyle,
                  ),
                  InkWell(
                    onTap: () {
                      if (_editPageController.status == kSuccessText) {
                        Get.back();
                      }
                    },
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    child: Obx(
                      () => _editPageController.status == kSuccessText
                          ? SvgPicture.asset(
                              kCloseIconPath,
                              width: kIconSize,
                              color: kPrimaryWhiteColor.withOpacity(1),
                            )
                          : const SizedBox(width: kIconSize),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildTimeSlider(),
              const SizedBox(height: 32),
              Obx(
                () => Text(
                  _editPageController.status,
                  style: kMediumTextStyle,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildTimeSlider() {
    return SizedBox(
      height: 120,
      width: 120,
      child: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              backgroundColor: kPrimaryWhiteColor.withOpacity(0.7),
              strokeWidth: 8,
              value: _editPageController.progressPercentage / 100,
              valueColor: const AlwaysStoppedAnimation(
                kPrimaryWhiteColor,
              ),
            ),
            Center(
              child: _editPageController.status == kSuccessText
                  ? const Icon(
                      Icons.check_rounded,
                      color: kPrimaryWhiteColor,
                      size: kIconSize,
                    )
                  : Text(
                      '${_editPageController.progressPercentage.round()}%',
                      textAlign: TextAlign.center,
                      style: kBoldTextStyle.copyWith(color: kPrimaryWhiteColor),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
