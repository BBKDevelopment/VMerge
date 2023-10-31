// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vmerge/controllers/controllers.dart';
import 'package:vmerge/controllers/home_page_controller.dart';
import 'package:vmerge/utilities/utilities.dart';
import 'package:vmerge/views/views.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: appTheme,
      home: VSoundPageView(),
    );
  }
}

class VSoundPageView extends StatelessWidget {
  VSoundPageView({super.key}) {
    _bottomBarController = Get.put(BottomBarController());
    _editPageController = Get.put(EditPageController());
    _homePageController = Get.put(HomePageController());
    _morePageController = Get.put(MorePageController());
  }
  late final BottomBarController _bottomBarController;
  late final EditPageController _editPageController;
  late final HomePageController _homePageController;
  late final MorePageController _morePageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _bottomBarController.pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) async {
            _bottomBarController.updateCurrentIndex(index);
            if (index == 1) {
              _editPageController.getAnimationController.duration =
                  kEditPageInAnimationDuration;
              await _editPageController.getAnimationController.forward();
              if (_homePageController.getVideoList.length == 2) {
                _editPageController
                    .updateAssets(_homePageController.getVideoList);
              }
            }
            if (index == 2) {
              _morePageController.getBeginList.clear();
              _morePageController.getEndList.clear();
              _morePageController.getAnimationController.duration =
                  kMorePageInAnimationDuration;
              await _morePageController.getAnimationController.forward();
            }
          },
          children: <Widget>[
            HomePage(),
            const EditPage(),
            MorePage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        color: kPrimaryColor,
        child: Obx(() {
          return BottomNavyBar(
            selectedIndex: _bottomBarController.currentIndex,
            onItemSelected: (index) async {
              if (_bottomBarController.currentIndex == 1 && index != 1) {
                _editPageController.getAnimationController.duration =
                    kEditPageOutAnimationDuration;
                await _editPageController.getAnimationController.reverse();
              }
              if (_bottomBarController.currentIndex == 2 && index != 2) {
                _morePageController.getAnimationController.duration =
                    kMorePageOutAnimationDuration;
                await _morePageController.getAnimationController.reverse();
              }
              _bottomBarController.updateCurrentIndex(index);
              _bottomBarController.pageController.jumpToPage(index);
            },
            backgroundColor: kPrimaryColor,
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                activeColor: kPrimaryWhiteColor,
                inactiveColor: kPrimaryWhiteColor,
                title: const Text('Home', style: kSemiBoldTextStyle),
                textAlign: TextAlign.center,
                icon: SvgPicture.asset(kHomeIconPath),
              ),
              BottomNavyBarItem(
                activeColor: kPrimaryWhiteColor,
                inactiveColor: kPrimaryWhiteColor,
                title: const Text('Edit', style: kSemiBoldTextStyle),
                textAlign: TextAlign.center,
                icon: SvgPicture.asset(kCutIconPath),
              ),
              BottomNavyBarItem(
                activeColor: kPrimaryWhiteColor,
                inactiveColor: kPrimaryWhiteColor,
                title: const Text('More', style: kSemiBoldTextStyle),
                textAlign: TextAlign.center,
                icon: SvgPicture.asset(kMoreIconPath),
              ),
            ],
          );
        }),
      ),
    );
  }
}
