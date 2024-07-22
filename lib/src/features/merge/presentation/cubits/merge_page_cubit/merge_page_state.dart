// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';
import 'package:vmerge/src/features/merge/merge.dart';

sealed class MergePageState extends Equatable {
  const MergePageState();
}

final class MergePageInitial extends MergePageState {
  const MergePageInitial();

  @override
  List<Object?> get props => [];
}

final class MergePageLoading extends MergePageState {
  const MergePageLoading();

  @override
  List<Object?> get props => [];
}

final class MergePageLoaded extends MergePageState {
  const MergePageLoaded({
    required this.videoMetadatas,
    required this.activeVideoIndex,
    required this.videoPlayerController,
    required this.videoHeight,
    required this.videoWidth,
    required this.isVideoPlaying,
  });

  final List<VideoMetadata> videoMetadatas;
  final int activeVideoIndex;
  final VideoPlayerController videoPlayerController;
  final double videoWidth;
  final double videoHeight;
  final bool isVideoPlaying;

  MergePageLoaded copyWith({
    List<VideoMetadata>? videoMetadatas,
    int? activeVideoIndex,
    VideoPlayerController? videoPlayerController,
    double? videoWidth,
    double? videoHeight,
    bool? isVideoPlaying,
  }) {
    return MergePageLoaded(
      videoMetadatas: videoMetadatas ?? this.videoMetadatas,
      activeVideoIndex: activeVideoIndex ?? this.activeVideoIndex,
      videoPlayerController:
          videoPlayerController ?? this.videoPlayerController,
      videoWidth: videoWidth ?? this.videoWidth,
      videoHeight: videoHeight ?? this.videoHeight,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
    );
  }

  @override
  List<Object?> get props => [
        videoMetadatas,
        activeVideoIndex,
        videoPlayerController,
        videoWidth,
        videoHeight,
        isVideoPlaying,
      ];
}

final class MergePageError extends MergePageState {
  const MergePageError({
    required this.errorType,
    this.error,
    this.stackTrace,
  });

  final MergePageErrorType errorType;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [
        errorType,
        error,
        stackTrace,
      ];
}

enum MergePageErrorType {
  insufficientVideoException,
  loadVideoException,
  playVideoException,
  pauseVideoException,
  setVideoPlaybackSpeedException,
  seekVideoPositionException,
  setVolumeException,
}
