// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vmerge/src/features/edit/edit.dart';
import 'package:vmerge/src/features/more/more.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:vmerge/src/features/preview/preview.dart';
import 'package:vmerge/utilities/utilities.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(
        const NavigationState(page: NavigationBarPage.preview),
      ),
      child: const _NavigationBarView(),
    );
  }
}

class _NavigationBarView extends StatelessWidget {
  const _NavigationBarView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) async {
            final page = NavigationBarPage.values[index];
            context.read<NavigationCubit>().updatePage(page);

            switch (page) {
              case NavigationBarPage.preview:
                break;
              case NavigationBarPage.edit:
                break;
              case NavigationBarPage.more:
                break;
            }

            // if (index == 1) {
            //   _editPageController.getAnimationController.duration =
            //       kEditPageInAnimationDuration;
            //   await _editPageController.getAnimationController.forward();
            //   if (_homePageController.getVideoList.length == 2) {
            //     _editPageController
            //         .updateAssets(_homePageController.getVideoList);
            //   }
            // }
            // if (index == 2) {
            //   _morePageController.getBeginList.clear();
            //   _morePageController.getEndList.clear();
            //   _morePageController.getAnimationController.duration =
            //       kMorePageInAnimationDuration;
            //   await _morePageController.getAnimationController.forward();
            // }
          },
          children: const [
            PreviewPage(),
            EditPage(),
            MorePage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        color: kPrimaryColor,
        child: BlocConsumer<NavigationCubit, NavigationState>(
          listener: (context, state) async {
            switch (state.page) {
              case NavigationBarPage.preview:
                context.read<PreviewCubit>().resetVideos();
              case NavigationBarPage.edit:
                break;
              case NavigationBarPage.more:
                break;
            }
          },
          builder: (context, state) {
            return BottomNavyBar(
              selectedIndex: state.page.index,
              onItemSelected: (index) async {
                // if (_bottomBarController.currentIndex == 1 && index != 1) {
                //   _editPageController.getAnimationController.duration =
                //       kEditPageOutAnimationDuration;
                //   await _editPageController.getAnimationController.reverse();
                // }
                // if (_bottomBarController.currentIndex == 2 && index != 2) {
                //   _morePageController.getAnimationController.duration =
                //       kMorePageOutAnimationDuration;
                //   await _morePageController.getAnimationController.reverse();
                // }
                // _bottomBarController.updateCurrentIndex(index);
                // _bottomBarController.pageController.jumpToPage(index);
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
          },
        ),
      ),
    );
  }
}
