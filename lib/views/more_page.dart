// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/controllers/controllers.dart';
import 'package:vmerge/services/abstracts/launcer_service.dart';
import 'package:vmerge/services/concretes/launcher_adapter.dart';
import 'package:vmerge/utilities/utilities.dart';

class MorePage extends StatelessWidget {
  MorePage({super.key}) {
    _morePageController = Get.find();
    _launcerService = LauncherAdapter();
  }

  late final MorePageController _morePageController;
  late final LauncerService _launcerService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VMergeAppBar(),
      body: Container(
        color: kPrimaryColorDark,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 4),
            _buildMorePageWidgets(),
            _buildBBKLogoAndCopyrightWidgets(),
          ],
        ),
      ),
    );
  }

  Expanded _buildMorePageWidgets() {
    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _morePageController.getMoreItemList.length + 1,
        itemBuilder: (context, index) {
          _morePageController.setStaggeredAnimation(index);
          return index == _morePageController.getMoreItemList.length
              ? const SizedBox()
              : AnimatedBuilder(
                  animation: _morePageController.getAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.2, 0),
                        end: const Offset(0, 0),
                      ).animate(
                        CurvedAnimation(
                          parent: _morePageController.getAnimation,
                          curve: Interval(
                            _morePageController.getBeginList[index],
                            _morePageController.getEndList[index],
                            curve: Curves.easeInOutCubic,
                          ),
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: InkWell(
                    onTap: () => _morePageController.onTappedItem(index),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    child: ListTile(
                      leading: SvgPicture.asset(
                        _morePageController.getMoreItemList[index].iconPath,
                      ),
                      title: Text(
                        _morePageController.getMoreItemList[index].title,
                        style: kSemiBoldTextStyle,
                      ),
                    ),
                  ),
                );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: kPrimaryColor,
            thickness: 1,
            height: 4,
          );
        },
      ),
    );
  }

  Column _buildBBKLogoAndCopyrightWidgets() {
    return Column(
      children: [
        InkWell(
          onTap: () async =>
              await _launcerService.launchUrl(kBBKDevelopmentOfficial),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          highlightColor: Colors.transparent,
          child: AnimatedBuilder(
            animation: _morePageController.getAnimation,
            builder: (BuildContext context, Widget? child) {
              return SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: _morePageController.getAnimation,
                  curve: Interval(
                    _morePageController.getEndList.isEmpty
                        ? 0.0
                        : _morePageController.getEndList.last,
                    1,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              );
            },
            child: Center(
              child: Image.asset(
                kBBKLogoIconPath,
                height: kIconSize * 2,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        AnimatedBuilder(
          animation: _morePageController.getAnimation,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: _morePageController.getAnimation,
                curve: Interval(
                  _morePageController.getEndList.isEmpty
                      ? 0.0
                      : _morePageController.getEndList.last,
                  1,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: child,
            );
          },
          child: const Center(
            child: Text(
              kCopyrightText,
              style: kSmallLightTextStyle,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
