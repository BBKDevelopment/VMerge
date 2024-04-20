// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _ControlButtonRow extends StatelessWidget {
  const _ControlButtonRow({
    required this.animation,
  });

  final Animation<double> animation;

  void _onTapSettings(BuildContext context) {
    if (context.read<MergePageCubit>().state is! MergePageLoaded) return;

    context.read<MergePageCubit>().stopVideo();

    // `showModalBottomSheet` is not used here since it does not support `Hero`
    // animations. Please see: https://github.com/flutter/flutter/issues/48467
    showCupertinoModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      topRadius: const Radius.circular(AppBorderRadius.xxxLarge),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<MergePageCubit>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<SettingsBottomSheetCubit>(context),
            ),
          ],
          // Default `showModalBottomSheet` and dialogs use
          // `dialogBackgroundColor` and `surfaceTintColor`, so `Card` is
          // used here to match the design because it uses the same colors.
          child: const Card(
            margin: EdgeInsets.zero,
            shape: ContinuousRectangleBorder(),
            child: _SettingsBottomSheet(),
          ),
        );
      },
    );
  }

  void _onTapSaveVideo(BuildContext context) {
    final mergePageState = context.read<MergePageCubit>().state;
    if (mergePageState is! MergePageLoaded) return;

    context.read<MergePageCubit>().stopVideo();

    // `showModalBottomSheet` is not used here since it does not support `Hero`
    // animations. Please see: https://github.com/flutter/flutter/issues/48467
    showCupertinoModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      topRadius: const Radius.circular(AppBorderRadius.xxxLarge),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<SaveBottomSheetCubit>(context)
          ..init(mergePageState.videoMetadatas),
        // Default `showModalBottomSheet` and dialogs use
        // `dialogBackgroundColor` and `surfaceTintColor`, so `Card` is used
        // here to match the design because it uses the same colors.
        child: const Card(
          margin: EdgeInsets.zero,
          shape: ContinuousRectangleBorder(),
          child: _SaveBottomSheet(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(
                    0,
                    0.5,
                    curve: Curves.easeOut,
                  ),
                ),
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(
                        0,
                        0.5,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: FilledButton.tonalIcon(
              onPressed:
                  context.watch<MergePageCubit>().state is MergePageLoaded
                      ? () => _onTapSettings(context)
                      : null,
              label: Text(context.l10n.settings),
              icon: Hero(
                tag: 'settings',
                child: Assets.images.settings.svg(
                  height: AppIconSize.xSmall,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onSecondaryContainer,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: AppPadding.large,
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(
                    0,
                    0.7,
                    curve: Curves.easeOut,
                  ),
                ),
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(
                        0,
                        0.7,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: OutlinedButton.icon(
              onPressed:
                  context.watch<MergePageCubit>().state is MergePageLoaded
                      ? () => _onTapSaveVideo(context)
                      : null,
              label: Text(context.l10n.saveVideo),
              icon: Hero(
                tag: 'save',
                child: Assets.images.save.svg(
                  height: AppIconSize.xSmall,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onSecondaryContainer,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
