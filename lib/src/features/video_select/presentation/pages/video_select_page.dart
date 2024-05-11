// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/src/components/components.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/error/error.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:vmerge/src/features/video_select/video_select.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part '../widgets/video_select_page_listener.dart';

class VideoSelectPage extends StatelessWidget {
  const VideoSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoSelectPageCubit>(
      create: (_) => VideoSelectPageCubit(const VideoSelectPageLoading()),
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
            // AppBarTheme is used for the app bar in the picker.
            appBarTheme: context.theme.appBarTheme.copyWith(
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor:
                    context.colorScheme.secondaryContainer,
                systemNavigationBarDividerColor:
                    context.colorScheme.secondaryContainer,
                systemNavigationBarIconBrightness:
                    context.theme.brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light,
              ),
            ),
            // BottomAppBarTheme is used for the bottom bar in the picker.
            bottomAppBarTheme: context.theme.bottomAppBarTheme.copyWith(
              color: context.colorScheme.secondaryContainer,
            ),
            // IconTheme is used for the loading indicator and the icons in the
            // picker.
            iconTheme: context.theme.iconTheme.copyWith(
              color: context.colorScheme.primary,
            ),
            // ColorScheme is used for the select indicator in the picker.
            colorScheme: context.colorScheme.copyWith(
              secondary: context.colorScheme.primary,
            ),
            // TextTheme is used for the index and confirm text in the picker.
            textTheme: context.theme.textTheme.copyWith(
              bodyLarge: context.theme.textTheme.bodyLarge!.copyWith(
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
          textDelegate: _getAssetPickerTextDelegateFromLocale(
            Localizations.localeOf(context),
          ),
        ),
      );
    } catch (error, stackTrace) {
      assets = null;
      if (!mounted) return;
      context.read<ErrorCubit>().caught(
            message: context.l10n.couldNotOpenAssetPickerMessage,
            error: error,
            stackTrace: stackTrace,
          );
    }

    if (!mounted) return;
    await context.read<VideoSelectPageCubit>().updateVideos(assets);
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
    final l10n = context.l10n;

    return _VideoSelectPageListener(
      child: Scaffold(
        appBar: CustomAppBar(title: l10n.appName),
        body: Padding(
          padding: AppPadding.general,
          child: BlocConsumer<VideoSelectPageCubit, VideoSelectPageState>(
            listener: (context, state) {
              switch (state) {
                case VideoSelectPageLoading():
                  _openAssetPicker();
                  _animationController.reset();
                case VideoSelectPageLoaded():
                  context.read<AppNavigationBarCubit>().updatePage(
                        NavigationBarPage.merge,
                        args: state.metadataList,
                      );
                case VideoSelectPageError():
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _animationController.forward(),
                  );
              }
            },
            builder: (context, state) {
              return switch (state) {
                VideoSelectPageLoading() => Center(
                    child: SizedBox.square(
                      dimension: context.screenWidth / 4 / 3,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                VideoSelectPageLoaded() => const SizedBox.shrink(),
                VideoSelectPageError() => AnimatedBuilder(
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
                      onPressed:
                          context.read<VideoSelectPageCubit>().resetVideos,
                    ),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}
