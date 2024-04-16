// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';

/// {@template video_detail}
/// A model class that contains the details of a video.
/// {@endtemplate}
final class VideoDetail extends Equatable {
  /// {@macro video_detail}
  const VideoDetail({
    required this.directory,
    required this.width,
    required this.height,
    required this.format,
    required this.codec,
    required this.frameRate,
    required this.hasAudio,
    required this.audioSampleRate,
    required this.audioChannelLayout,
    required this.duration,
  });

  /// The directory of the video.
  final String directory;

  /// The width of the video.
  final int? width;

  /// The height of the video.
  final int? height;

  /// The format of the video.
  final String? format;

  /// The codec of the video.
  final String? codec;

  /// The frame rate of the video.
  final String? frameRate;

  /// Indicates whether the video has audio.
  final bool hasAudio;

  /// The audio sample rate of the video.
  final String? audioSampleRate;

  /// The audio channel layout of the video.
  final String? audioChannelLayout;

  /// The duration of the video in milliseconds.
  final int? duration;

  @override
  String toString() {
    return 'VideoInfo(directory: $directory, width: $width, height: $height, '
        'format: $format, codec: $codec, frameRate: $frameRate, hasAudio: '
        '$hasAudio, audioSampleRate: $audioSampleRate, audioChannelLayout: '
        '$audioChannelLayout, duration: $duration)';
  }

  @override
  List<Object?> get props => [
        directory,
        width,
        height,
        format,
        codec,
        frameRate,
        hasAudio,
        audioSampleRate,
        audioChannelLayout,
        duration,
      ];
}
