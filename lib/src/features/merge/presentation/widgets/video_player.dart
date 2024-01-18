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
      child: BlocBuilder<MergeCubit, MergeState>(
        buildWhen: (previous, current) {
          if (current is MergeError) return false;

          return true;
        },
        builder: (context, state) {
          switch (state) {
            case MergeInitial():
              return NoVideoWarning(
                onPressed: () => context
                    .read<NavigationCubit>()
                    .updatePage(NavigationBarPage.previewVideo),
              );
            case MergeLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MergeLoaded():
              return Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (state.isVideoPlaying) {
                        animatedControlButtonController.reverse();
                        context.read<MergeCubit>().stopVideo();
                      } else {
                        animatedControlButtonController.forward();
                        context.read<MergeCubit>().playVideo();
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: state.videoWidth / state.videoHeight,
                      child: ClipRRect(
                        borderRadius: AppBorderRadius.circularXSmall,
                        child: VideoPlayer(state.videoPlayerController),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: state.isVideoPlaying ? 0.0 : 1.0,
                    child: AnimatedControlButton(
                      controller: animatedControlButtonController,
                    ),
                  ),
                ],
              );

            case MergeError():
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}