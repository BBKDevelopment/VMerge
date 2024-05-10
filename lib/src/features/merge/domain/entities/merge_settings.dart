// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:vmerge/src/core/core.dart';

final class MergeSettings extends DomainEntity {
  const MergeSettings({
    required this.isAudioOn,
    required this.playbackSpeed,
    required this.videoResolution,
    required this.videoAspectRatio,
  });

  final bool isAudioOn;
  final PlaybackSpeed playbackSpeed;
  final VideoResolution videoResolution;
  final VideoAspectRatio videoAspectRatio;

  @override
  String toString() {
    return 'MergeSettings(isSoundOn: $isAudioOn, playbackSpeed: $playbackSpeed,'
        ' videoResolution: $videoResolution, videoAspectRatio: '
        '$videoAspectRatio)';
  }

  @override
  List<Object> get props => [
        isAudioOn,
        playbackSpeed,
        videoResolution,
        videoAspectRatio,
      ];
}

enum PlaybackSpeed {
  zeroPointFive(0.5),
  one(1),
  onePointFive(1.5),
  two(2);

  const PlaybackSpeed(this.value);

  final double value;

  @override
  String toString() {
    return name;
  }

  static PlaybackSpeed fromString(String value) {
    final playbackSpeed = PlaybackSpeed.values
        .firstWhereOrNull((playbackSpeed) => playbackSpeed.toString() == value);

    return playbackSpeed ?? PlaybackSpeed.one;
  }

  static PlaybackSpeed? fromValue(double value) {
    return PlaybackSpeed.values
        .firstWhereOrNull((playbackSpeed) => playbackSpeed.value == value);
  }
}

enum VideoResolution {
  veryLow('240p', 426, 240, '16:9'),
  low('360p', 480, 360, '4:3'),
  medium('480p', 640, 480, '4:3'),
  high('720p', 1280, 720, '16:9'),
  veryHigh('1080p', 1920, 1080, '16:9'),
  ultraHigh('1440p', 2560, 1440, '16:9'),
  original('Original', null, null, null);

  const VideoResolution(this.value, this.width, this.height, this.aspectRatio);

  final String value;
  final double? width;
  final double? height;
  final String? aspectRatio;

  @override
  String toString() {
    return name;
  }

  static VideoResolution fromString(String value) {
    final videoResolution = VideoResolution.values.firstWhereOrNull(
      (videoResolution) => videoResolution.toString() == value,
    );

    return videoResolution ?? VideoResolution.original;
  }
}

enum VideoAspectRatio {
  independent,
  firstVideo,
  auto;

  @override
  String toString() {
    return name;
  }

  static VideoAspectRatio fromString(String value) {
    final videoAspectRatio = VideoAspectRatio.values
        .firstWhereOrNull((element) => element.toString() == value);

    return videoAspectRatio ?? VideoAspectRatio.independent;
  }
}
