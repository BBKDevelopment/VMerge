// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/edit_page.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({super.key, this.metadata});

  final VideoMetadata? metadata;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kGridViewItemsBorderRadius),
      child: SizedBox(
        height: 120,
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ColoredBox(
                color:
                    metadata != null ? kPrimaryColorDark : kPrimaryWhiteColor,
                child: metadata != null
                    ? Image.memory(metadata!.thumbnail!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.video_library_rounded,
                        color: kPrimaryColor,
                        size: 60,
                      ),
              ),
            ),
            Container(
              height: 18,
              color: kPrimaryColor,
              alignment: Alignment.center,
              child: Text(
                metadata != null
                    ? TimeFormatter.format(
                        duration: Duration(seconds: metadata!.duration!),
                      )
                    : 'NON',
                style: kRegularTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
