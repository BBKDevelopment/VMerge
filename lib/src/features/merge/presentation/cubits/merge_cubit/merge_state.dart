// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';
import 'package:vmerge/src/features/merge/merge.dart';

sealed class MergeState extends Equatable {
  const MergeState();
}

final class MergeInitial extends MergeState {
  const MergeInitial();

  @override
  List<Object> get props => [];
}

final class MergeLoading extends MergeState {
  const MergeLoading();

  @override
  List<Object> get props => [];
}

final class MergeLoaded extends MergeState {
  const MergeLoaded({
    required this.metadatas,
    required this.activeVideoIndex,
    required this.videoPlayerController,
    required this.videoHeight,
    required this.videoWidth,
    required this.isVideoPlaying,
    required this.isSoundOn,
    required this.playbackSpeed,
    required this.videoResolution,
    required this.videoAspectRatio,
    required this.saveModalBottomSheetStatus,
  });

  final List<VideoMetadata> metadatas;
  final ActiveVideoIndex activeVideoIndex;
  final VideoPlayerController videoPlayerController;
  final double videoWidth;
  final double videoHeight;
  final bool isVideoPlaying;
  final bool isSoundOn;
  final PlaybackSpeed playbackSpeed;
  final VideoResolution videoResolution;
  final VideoAspectRatio videoAspectRatio;
  final SaveModalBottomSheetStatus saveModalBottomSheetStatus;

  MergeLoaded copyWith({
    List<VideoMetadata>? metadatas,
    ActiveVideoIndex? activeVideoIndex,
    VideoPlayerController? videoPlayerController,
    double? videoWidth,
    double? videoHeight,
    bool? isVideoPlaying,
    bool? isSoundOn,
    PlaybackSpeed? playbackSpeed,
    VideoResolution? videoResolution,
    VideoAspectRatio? videoAspectRatio,
    SaveModalBottomSheetStatus? saveModalBottomSheetStatus,
  }) {
    return MergeLoaded(
      metadatas: metadatas ?? this.metadatas,
      activeVideoIndex: activeVideoIndex ?? this.activeVideoIndex,
      videoPlayerController:
          videoPlayerController ?? this.videoPlayerController,
      videoWidth: videoWidth ?? this.videoWidth,
      videoHeight: videoHeight ?? this.videoHeight,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
      isSoundOn: isSoundOn ?? this.isSoundOn,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      videoResolution: videoResolution ?? this.videoResolution,
      videoAspectRatio: videoAspectRatio ?? this.videoAspectRatio,
      saveModalBottomSheetStatus:
          saveModalBottomSheetStatus ?? this.saveModalBottomSheetStatus,
    );
  }

  @override
  List<Object> get props => [
        metadatas,
        activeVideoIndex,
        videoPlayerController,
        videoWidth,
        videoHeight,
        isVideoPlaying,
        isSoundOn,
        playbackSpeed,
        videoResolution,
        videoAspectRatio,
        saveModalBottomSheetStatus,
      ];
}

final class MergeError extends MergeState {
  const MergeError();

  @override
  List<Object> get props => [];
}

enum ActiveVideoIndex {
  one,
  two,
}

enum SaveModalBottomSheetStatus {
  idle,
  saving,
  saved,
  error,
}
