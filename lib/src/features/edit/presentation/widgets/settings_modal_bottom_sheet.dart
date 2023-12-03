// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/edit_page.dart';

class SettingsModalBottomSheet extends StatelessWidget {
  const SettingsModalBottomSheet({super.key});

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
                    onTap: Navigator.of(context).pop,
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
              _getSliderTheme(
                context: context,
                child: Obx(() {
                  return Slider(
                    value: 1, //_editPageController.speedValue,
                    max: 7,
                    divisions: 7,
                    label: '_editPageController.speedValueText',
                    onChanged: (_) {}, //_editPageController.setSpeed,
                  );
                }),
              ),
              const SizedBox(height: 32),
              const Text(kVideoQualityText, style: kRegularTextStyle),
              const SizedBox(height: 32),
              _getSliderTheme(
                context: context,
                child: Obx(() {
                  return Slider(
                    value: 1, //_editPageController.qualityValue,
                    max: 6,
                    divisions: 6,
                    label: '_editPageController.qualityValueText',
                    onChanged: (_) {}, //_editPageController.setQuality,
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
