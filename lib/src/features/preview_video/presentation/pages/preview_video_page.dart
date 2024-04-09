// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/src/components/components.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:vmerge/src/features/preview_video/preview_video.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PreviewVideoPage extends StatelessWidget {
  const PreviewVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreviewVideoCubit>(
      create: (_) => PreviewVideoCubit(const PreviewVideoLoading()),
      child: const _PreviewVideoView(),
    );
  }
}

class _PreviewVideoView extends StatefulWidget {
  const _PreviewVideoView();

  @override
  State<_PreviewVideoView> createState() => _PreviewVideoViewState();
}

class _PreviewVideoViewState extends State<_PreviewVideoView>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimationDuration.short,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((_) => _openAssetPicker());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openAssetPicker() async {
    List<AssetEntity>? assets;
    try {
      assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 4,
          requestType: RequestType.video,
          specialPickerType: SpecialPickerType.noPreview,
          pickerTheme: context.theme.copyWith(
            appBarTheme: context.theme.appBarTheme.copyWith(
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor:
                    context.colorScheme.secondaryContainer,
                systemNavigationBarIconBrightness: context.theme.brightness,
              ),
            ),
            bottomAppBarTheme: context.theme.bottomAppBarTheme.copyWith(
              color: context.colorScheme.secondaryContainer,
            ),
          ),
          textDelegate: _getAssetPickerTextDelegateFromLocale(
            Localizations.localeOf(context),
          ),
        ),
      );
    } catch (_) {
      assets = null;
    }

    if (!mounted) return;

    await context.read<PreviewVideoCubit>().updateVideos(assets);
  }

  AssetPickerTextDelegate _getAssetPickerTextDelegateFromLocale(Locale locale) {
    final languageCode = locale.languageCode.toLowerCase();
    for (final delegate in assetPickerTextDelegates) {
      if (delegate.languageCode != languageCode) continue;

      return delegate;
    }

    return const EnglishAssetPickerTextDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.appName),
      body: Padding(
        padding: AppPadding.general,
        child: BlocConsumer<PreviewVideoCubit, PreviewVideoState>(
          listener: (context, state) {
            switch (state) {
              case PreviewVideoLoading():
                _openAssetPicker();
                _animationController.reset();
              case PreviewVideoLoaded():
                context.read<AppNavigationBarCubit>().updatePage(
                      NavigationBarPage.merge,
                      args: state.metadataList,
                    );
              case PreviewVideoError():
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _animationController.forward(),
                );
            }
          },
          builder: (context, state) {
            return switch (state) {
              PreviewVideoLoading() => Center(
                  child: SizedBox.square(
                    dimension: context.screenWidth / 4 / 3,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.theme.iconTheme.color!,
                      ),
                    ),
                  ),
                ),
              PreviewVideoLoaded() => const SizedBox.shrink(),
              PreviewVideoError() => AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animation,
                        curve: const Interval(
                          0,
                          1,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, -0.05),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animation,
                            curve: const Interval(
                              0,
                              1,
                              curve: Curves.easeOut,
                            ),
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: NoVideoWarning(
                    onPressed: context.read<PreviewVideoCubit>().resetVideos,
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
