// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _VideoThumbnail extends StatelessWidget {
  const _VideoThumbnail({
    required this.animation,
    required this.index,
    this.metadata,
  });

  final Animation<double> animation;
  final int index;
  final VideoMetadata? metadata;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Interval(
              0,
              0.6 + (index + 1) / 10,
              curve: Curves.easeOut,
            ),
          ),
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0.2, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0,
                  0.6 + (index + 1) / 10,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: child,
          ),
        );
      },
      child: SizedBox.square(
        dimension: context.screenWidth / 4,
        child: Card(
          margin: AppPadding.bottomXXSmall,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.circularXSmall,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: metadata?.thumbnail != null
                    ? Image.memory(
                        metadata!.thumbnail!,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.video_library_rounded,
                        size: AppIconSize.xLarge,
                      ),
              ),
              Text(
                metadata != null
                    ? TimeFormatter.format(
                        duration: Duration(seconds: metadata!.duration!),
                      )
                    : 'NON',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
