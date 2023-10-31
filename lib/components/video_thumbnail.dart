// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vmerge/models/models.dart';
import 'package:vmerge/utilities/utilities.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({super.key, this.video});

  final Video? video;

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
              child: Container(
                color: video != null ? kPrimaryColorDark : kPrimaryWhiteColor,
                child: video != null
                    ? Image.memory(video!.image!, fit: BoxFit.cover)
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
                video != null
                    ? TimeFormatter.format(
                        duration: Duration(seconds: video!.duration!),
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
