// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:vmerge/src/features/merge/merge.dart';

sealed class VideoSelectPageState extends Equatable {
  const VideoSelectPageState();
}

final class VideoSelectPageLoading extends VideoSelectPageState {
  const VideoSelectPageLoading();

  @override
  List<Object?> get props => [];
}

final class VideoSelectPageLoaded extends VideoSelectPageState {
  const VideoSelectPageLoaded({required this.metadataList});

  final List<VideoMetadata> metadataList;

  @override
  List<Object?> get props => [metadataList];
}

final class VideoSelectPageError extends VideoSelectPageState {
  const VideoSelectPageError();

  @override
  List<Object?> get props => [];
}
