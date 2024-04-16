// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:vmerge/src/features/more/more.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:vmerge/src/features/preview_video/preview_video.dart';

part 'navigation_confirm_dialog.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppNavigationBarCubit(),
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
      initialPage: context.read<AppNavigationBarCubit>().state.page.index,
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
    final bottomNavigationBarColor = context.colorScheme.secondaryContainer;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: bottomNavigationBarColor,
        systemNavigationBarIconBrightness: context.theme.brightness,
      ),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            PreviewVideoPage(),
            MergePage(),
            MorePage(),
          ],
        ),
        bottomNavigationBar:
            BlocConsumer<AppNavigationBarCubit, AppNavigationBarState>(
          listener: (context, state) {
            _pageController.jumpToPage(state.page.index);
          },
          builder: (context, state) {
            return BottomNavyBar(
              selectedIndex: state.page.index,
              backgroundColor: bottomNavigationBarColor,
              showElevation: false,
              onItemSelected: (index) async {
                if (!state.isSafeToNavigate) {
                  final canNavigate = await showDialog<bool>(
                    context: context,
                    builder: (_) => const _NavigationConfirmDialog(),
                  );

                  if (canNavigate == null || !canNavigate) return;
                }

                if (!context.mounted) return;
                final page = NavigationBarPage.values[index];
                context.read<AppNavigationBarCubit>().updatePage(page);
              },
              items: [
                BottomNavyBarItem(
                  activeColor: context.colorScheme.secondary,
                  title: Text(
                    l10n.video,
                    style: context.textTheme.titleMedium,
                  ),
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
