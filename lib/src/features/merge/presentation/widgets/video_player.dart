// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _VideoPlayer extends StatelessWidget {
  const _VideoPlayer({
    required this.videoPlayerController,
    required this.animatedControlButtonController,
    required this.videoWidth,
    required this.videoHeight,
    required this.onTap,
  });

  final VideoPlayerController videoPlayerController;
  final AnimatedControlButtonController animatedControlButtonController;
  final double videoWidth;
  final double videoHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FittedBox(
            child: SizedBox(
              width: videoWidth,
              height: videoHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: VideoPlayer(videoPlayerController),
              ),
            ),
          ),
        ),
        BlocSelector<MergeCubit, MergeState, bool>(
          selector: (state) {
            if (state is! MergeLoaded) return false;

            return state.isVideoPlaying;
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: state ? 0.0 : 1.0,
                  child: AnimatedControlButton(
                    controller: animatedControlButtonController,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
