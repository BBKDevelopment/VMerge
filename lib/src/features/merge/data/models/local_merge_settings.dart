// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

@Entity()
final class LocalMergeSettings implements DataModel<MergeSettings> {
  LocalMergeSettings()
      : id = 0,
        isSoundOn = true,
        playbackSpeed = PlaybackSpeed.one.toString(),
        videoResolution = VideoResolution.original.toString(),
        videoAspectRatio = VideoAspectRatio.firstVideo.toString();

  LocalMergeSettings.fromArgs({
    required this.isSoundOn,
    required this.playbackSpeed,
    required this.videoResolution,
    required this.videoAspectRatio,
  }) : id = 0;

  LocalMergeSettings.fromEntity(MergeSettings entity)
      : this.fromArgs(
          isSoundOn: entity.isAudioOn,
          playbackSpeed: entity.playbackSpeed.toString(),
          videoResolution: entity.videoResolution.toString(),
          videoAspectRatio: entity.videoAspectRatio.toString(),
        );

  int id;
  bool isSoundOn;
  String playbackSpeed;
  String videoResolution;
  String videoAspectRatio;

  @override
  MergeSettings toEntity() {
    return MergeSettings(
      isAudioOn: isSoundOn,
      playbackSpeed: PlaybackSpeed.fromString(playbackSpeed),
      videoResolution: VideoResolution.fromString(videoResolution),
      videoAspectRatio: VideoAspectRatio.fromString(videoAspectRatio),
    );
  }
}
