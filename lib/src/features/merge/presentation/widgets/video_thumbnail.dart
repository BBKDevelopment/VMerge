// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({super.key, this.metadata});

  final VideoMetadata? metadata;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 120,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: AppPadding.xSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: metadata != null
                  ? Image.memory(metadata!.thumbnail!, fit: BoxFit.cover)
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
    );
  }
}
