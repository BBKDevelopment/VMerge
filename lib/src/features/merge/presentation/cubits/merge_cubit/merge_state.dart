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
    required this.videoQuality,
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
  final VideoQuality videoQuality;
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
    VideoQuality? videoQuality,
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
      videoQuality: videoQuality ?? this.videoQuality,
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
        videoQuality,
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

enum PlaybackSpeed {
  zeroPointTwoFive(0.25),
  zeroPointFive(0.5),
  zeroPointSevenFive(0.75),
  one(1),
  onePointTwoFive(1.25),
  onePointFive(1.5),
  onePointSevenFive(1.75),
  two(2);

  const PlaybackSpeed(this.value);

  final double value;
}

enum VideoQuality {
  veryLow(0),
  low(1),
  medium(2),
  high(3),
  veryHigh(4),
  ultraHigh(5),
  original(6);

  const VideoQuality(this.value);

  final int value;
}

enum SaveModalBottomSheetStatus {
  idle,
  saving,
  saved,
  error,
}
