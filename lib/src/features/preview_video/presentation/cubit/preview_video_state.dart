// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:vmerge/src/features/merge/merge.dart';

sealed class PreviewVideoState extends Equatable {
  const PreviewVideoState();
}

final class PreviewVideoLoading extends PreviewVideoState {
  const PreviewVideoLoading();

  @override
  List<Object?> get props => [];
}

final class PreviewVideoLoaded extends PreviewVideoState {
  const PreviewVideoLoaded({required this.metadataList});

  final List<VideoMetadata> metadataList;

  @override
  List<Object?> get props => [metadataList];
}

final class PreviewVideoError extends PreviewVideoState {
  const PreviewVideoError();

  @override
  List<Object?> get props => [];
}
