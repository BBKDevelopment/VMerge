import 'package:equatable/equatable.dart';

final class VideoInformation extends Equatable {
  const VideoInformation({
    required this.directory,
    required this.width,
    required this.height,
    required this.format,
    required this.codec,
    required this.frameRate,
    required this.hasAudio,
    required this.audioSampleRate,
    required this.audioChannelLayout,
  });

  final String directory;
  // Not important for fast concat -> But all videos takes the first video's width.
  final int? width;
  // Not important for fast concat -> But all videos takes the first video's height.
  final int? height;
  final String? format;
  final String? codec;
  // Not important for fast concat.
  final String? frameRate;
  // Not important for fast concat.
  final bool hasAudio;
  final String? audioSampleRate;
  final String? audioChannelLayout;

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
      ];
}
