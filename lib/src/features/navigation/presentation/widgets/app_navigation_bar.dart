// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/edit/edit.dart';
import 'package:vmerge/src/features/more/more.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:vmerge/src/features/preview_video/preview.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(
        const NavigationState(page: NavigationBarPage.preview),
      ),
      child: const _AppNavigationBarView(),
    );
  }
}

class _AppNavigationBarView extends StatefulWidget {
  const _AppNavigationBarView();

  @override
  State<_AppNavigationBarView> createState() => _AppNavigationBarViewState();
}

class _AppNavigationBarViewState extends State<_AppNavigationBarView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: context.read<NavigationCubit>().state.page.index,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: PageView(
        controller: _pageController,
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
          PreviewVideoPage(),
          EditPage(),
          MorePage(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: AppPadding.horizontalMedium,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.theme.dividerColor,
            ),
          ),
        ),
        child: BlocConsumer<NavigationCubit, NavigationState>(
          listener: (context, state) async {
            switch (state.page) {
              case NavigationBarPage.preview:
                _pageController.jumpToPage(state.page.index);
              case NavigationBarPage.edit:
                break;
              case NavigationBarPage.more:
                break;
            }
          },
          builder: (context, state) {
            return BottomNavyBar(
              selectedIndex: state.page.index,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              showElevation: false,
              onItemSelected: (index) async {
                _pageController.jumpToPage(index);
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
              items: [
                BottomNavyBarItem(
                  activeColor: context.colorScheme.secondary,
                  title: Text(l10n.video, style: context.textTheme.titleMedium),
                  textAlign: TextAlign.center,
                  icon: Assets.images.video.svg(
                    height: AppIconSize.medium,
                    width: AppIconSize.medium,
                    colorFilter: ColorFilter.mode(
                      context.theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                BottomNavyBarItem(
                  activeColor: context.colorScheme.secondary,
                  title: Text(l10n.merge, style: context.textTheme.titleMedium),
                  textAlign: TextAlign.center,
                  icon: Assets.images.merge.svg(
                    height: AppIconSize.medium,
                    width: AppIconSize.medium,
                    colorFilter: ColorFilter.mode(
                      context.theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                BottomNavyBarItem(
                  activeColor: context.colorScheme.secondary,
                  title: Text(l10n.more, style: context.textTheme.titleMedium),
                  textAlign: TextAlign.center,
                  icon: Assets.images.more.svg(
                    height: AppIconSize.medium,
                    width: AppIconSize.medium,
                    colorFilter: ColorFilter.mode(
                      context.theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
