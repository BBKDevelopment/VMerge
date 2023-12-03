// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:vmerge/src/features/edit/edit.dart';

sealed class PreviewState extends Equatable {
  const PreviewState();
}

final class PreviewLoading extends PreviewState {
  const PreviewLoading();

  @override
  List<Object?> get props => [];
}

final class PreviewLoaded extends PreviewState {
  const PreviewLoaded({required this.metadatas});

  final List<VideoMetadata> metadatas;

  @override
  List<Object?> get props => [metadatas];
}

final class PreviewError extends PreviewState {
  const PreviewError();

  @override
  List<Object?> get props => [];
}
