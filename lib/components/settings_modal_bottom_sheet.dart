// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vmerge/controllers/controllers.dart';
import 'package:vmerge/utilities/utilities.dart';

class SettingsModalBottomSheet extends StatelessWidget {
  SettingsModalBottomSheet({super.key}) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: kIconSize),
                  const Text(
                    kSettingsText,
                    style: kBoldTextStyle,
                  ),
                  InkWell(
                    onTap: Get.back,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    child: SvgPicture.asset(
                      kCloseIconPath,
                      width: kIconSize,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(kVideoSpeedText, style: kRegularTextStyle),
              const SizedBox(height: 32),
              _buildSpeedSlider(context),
              const SizedBox(height: 32),
              const Text(kVideoQualityText, style: kRegularTextStyle),
              const SizedBox(height: 32),
              _buildQualitySlider(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  SliderTheme _buildSpeedSlider(BuildContext context) {
    return _getSliderTheme(
      context: context,
      child: Obx(() {
        return Slider(
          value: _editPageController.speedValue,
          max: 7,
          divisions: 7,
          label: _editPageController.speedValueText,
          onChanged: (value) {
            _editPageController.setSpeed(value);
          },
        );
      }),
    );
  }

  SliderTheme _buildQualitySlider(BuildContext context) {
    return _getSliderTheme(
      context: context,
      child: Obx(() {
        return Slider(
          value: _editPageController.qualityValue,
          max: 6,
          divisions: 6,
          label: _editPageController.qualityValueText,
          onChanged: (value) {
            _editPageController.setQuality(value);
          },
        );
      }),
    );
  }

  SliderTheme _getSliderTheme({
    required BuildContext context,
    required Widget child,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: kPrimaryWhiteColor,
        inactiveTrackColor: kPrimaryWhiteColor,
        trackShape: const RoundedRectSliderTrackShape(),
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        thumbColor: kPrimaryWhiteColor,
        overlayColor: kPrimaryWhiteColor.withOpacity(0.3),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
        tickMarkShape: const RoundSliderTickMarkShape(),
        activeTickMarkColor: kPrimaryWhiteColor,
        inactiveTickMarkColor: kPrimaryWhiteColor,
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: kPrimaryWhiteColor,
        valueIndicatorTextStyle:
            kSmallTextStyle.copyWith(color: kPrimaryColorDark),
      ),
      child: child,
    );
  }
}
