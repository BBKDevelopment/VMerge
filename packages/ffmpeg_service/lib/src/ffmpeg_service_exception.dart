// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:ffmpeg_service/ffmpeg_service.dart';

/// {@template ffmpeg_service_exception}
/// An exception thrown by the [FFmpegService].
/// {@endtemplate}
sealed class FFmpegServiceException implements Exception {
  /// {@macro ffmpeg_service_exception}
  const FFmpegServiceException();
}

/// {@template ffmpeg_service_initialisation_exception}
/// An exception thrown when the [FFmpegService] fails to initialise.
/// {@endtemplate}
final class FFmpegServiceInitialisationException
    extends FFmpegServiceException {
  /// {@macro ffmpeg_service_initialisation_exception}
  const FFmpegServiceInitialisationException();
}

/// {@template ffmpeg_service_not_initialised_exception}
/// An exception thrown when the [FFmpegService] is not initialised.
/// {@endtemplate}
final class FFmpegServiceNotInitialisedException
    extends FFmpegServiceException {
  /// {@macro ffmpeg_service_not_initialised_exception}
  const FFmpegServiceNotInitialisedException();
}

/// {@template ffmpeg_service_insufficient_videos_exception}
/// An exception thrown when there are insufficient videos to merge.
/// {@endtemplate}
final class FFmpegServiceInsufficientVideosException
    extends FFmpegServiceException {
  /// {@macro ffmpeg_service_insufficient_videos_exception}
  const FFmpegServiceInsufficientVideosException();
}

/// {@template ffmpeg_service_merge_exception}
/// An exception thrown when the [FFmpegService] fails to merge the videos.
/// {@endtemplate}
final class FFmpegServiceMergeException extends FFmpegServiceException {
  /// {@macro ffmpeg_service_merge_exception}
  const FFmpegServiceMergeException();
}
