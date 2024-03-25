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
  List<Object> get props => [];
}

final class MergePageLoading extends MergePageState {
  const MergePageLoading();

  @override
  List<Object> get props => [];
}

final class MergePageLoaded extends MergePageState {
  const MergePageLoaded({
    required this.metadatas,
    required this.activeVideoIndex,
    required this.videoPlayerController,
    required this.videoHeight,
    required this.videoWidth,
    required this.isVideoPlaying,
    required this.saveModalBottomSheetStatus,
  });

  final List<VideoMetadata> metadatas;
  final ActiveVideoIndex activeVideoIndex;
  final VideoPlayerController videoPlayerController;
  final double videoWidth;
  final double videoHeight;
  final bool isVideoPlaying;
  final SaveModalBottomSheetStatus saveModalBottomSheetStatus;

  MergePageLoaded copyWith({
    List<VideoMetadata>? metadatas,
    ActiveVideoIndex? activeVideoIndex,
    VideoPlayerController? videoPlayerController,
    double? videoWidth,
    double? videoHeight,
    bool? isVideoPlaying,
    SaveModalBottomSheetStatus? saveModalBottomSheetStatus,
  }) {
    return MergePageLoaded(
      metadatas: metadatas ?? this.metadatas,
      activeVideoIndex: activeVideoIndex ?? this.activeVideoIndex,
      videoPlayerController:
          videoPlayerController ?? this.videoPlayerController,
      videoWidth: videoWidth ?? this.videoWidth,
      videoHeight: videoHeight ?? this.videoHeight,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
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
        saveModalBottomSheetStatus,
      ];
}

final class MergePageError extends MergePageState {
  const MergePageError();

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
