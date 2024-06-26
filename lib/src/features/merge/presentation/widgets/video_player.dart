// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _VideoPlayer extends StatelessWidget {
  const _VideoPlayer({
    required this.animation,
    required this.animatedControlButtonController,
  });

  final Animation<double> animation;
  final AnimatedControlButtonController animatedControlButtonController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(
              0,
              0.3,
              curve: Curves.easeOut,
            ),
          ),
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, -0.05),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(
                  0,
                  0.3,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: child,
          ),
        );
      },
      child: BlocBuilder<MergePageCubit, MergePageState>(
        buildWhen: (previous, current) {
          if (previous is! MergePageLoaded) return true;
          if (current is! MergePageLoaded) return true;

          return previous.isVideoPlaying != current.isVideoPlaying ||
              previous.videoPlayerController != current.videoPlayerController;
        },
        builder: (context, state) {
          final videoResolution =
              context.select<SettingsBottomSheetCubit, VideoResolution>(
            (cubit) {
              return switch (cubit.state) {
                final SettingsBottomSheetLoaded state => state.videoResolution,
                _ => VideoResolution.original,
              };
            },
          );

          return switch (state) {
            MergePageInitial() => NoVideoWarning(
                onPressed: () => context
                    .read<AppNavigationBarCubit>()
                    .updatePage(NavigationBarPage.previewVideo),
              ),
            MergePageLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            MergePageLoaded() => GestureDetector(
                onTap: () {
                  if (state.isVideoPlaying) {
                    animatedControlButtonController.reverse();
                    context.read<MergePageCubit>().stopVideo();
                  } else {
                    animatedControlButtonController.forward();
                    context.read<MergePageCubit>().playVideo();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: (videoResolution.width ?? state.videoWidth) /
                          (videoResolution.height ?? state.videoHeight),
                      child: ClipRRect(
                        borderRadius: AppBorderRadius.circularXSmall,
                        child: VideoPlayer(state.videoPlayerController),
                      ),
                    ),
                    AnimatedControlButton(
                      controller: animatedControlButtonController,
                    ),
                  ],
                ),
              ),
            MergePageError() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
