import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/media_information_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/statistics.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/stream_information.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:vmerge/src/features/merge/presentation/cubits/video_information.dart';

/// Callback to report the progress of the FFmpeg command.
typedef ProgressCallback = void Function(double progress);

final class FFmpegService {
  FFmpegService()
      : _videoInfos = List.empty(growable: true),
        _isAudioSameOnAll = null,
        _isReencodingRequired = null;

  final List<VideoInfo> _videoInfos;
  bool? _isResolutionSameOnAll;
  bool? _isFormatSameOnAll;
  bool? _isCodecSameOnAll;
  bool? _isFrameRateSameOnAll;
  bool? _isAudioSameOnAll;
  bool? _isReencodingRequired;

  Future<void> initThenAnalyseVideos({required List<String> inputDirs}) async {
    // Disposes the previous state.
    _dispose();

    for (final inputDir in inputDirs) {
      await _initVideo(inputDir);
    }

    // Analyse the videos to determine if re-encoding is required and if audio
    // is available for all videos.
    _analyseVideos();
  }

  Future<void> _initVideo(String dir) async {
    final mediaInformationSession = await FFprobeKit.getMediaInformation(dir);
    final videoStream = mediaInformationSession
        .getMediaInformation()
        ?.getStreams()
        .firstWhereOrNull(
          (stream) => stream.getType()?.toUpperCase() == 'VIDEO',
        );
    final audioStream = mediaInformationSession
        .getMediaInformation()
        ?.getStreams()
        .firstWhereOrNull(
          (stream) => stream.getType()?.toUpperCase() == 'AUDIO',
        );
    final resolution = _getResolutionBasedOnRotation(videoStream);
    final duration = _getDuration(mediaInformationSession);
    final videoInformation = VideoInfo(
      directory: dir,
      width: resolution.width,
      height: resolution.height,
      format: mediaInformationSession.getMediaInformation()?.getFormat(),
      codec: videoStream?.getCodec(),
      frameRate: videoStream?.getRealFrameRate(),
      hasAudio: audioStream != null,
      audioSampleRate: audioStream?.getSampleRate(),
      audioChannelLayout: audioStream?.getChannelLayout(),
      duration: duration,
    );
    _videoInfos.add(videoInformation);
  }

  // Check if the video is rotated and returns the video width and height based
  // on the rotation.
  ({int? height, int? width}) _getResolutionBasedOnRotation(
    StreamInformation? videoStream,
  ) {
    final width = videoStream?.getWidth();
    final height = videoStream?.getHeight();

    final sideDataList =
        videoStream?.getProperty('side_data_list') as List<Object?>?;
    if (sideDataList == null) return (width: width, height: height);

    final rotation = sideDataList.map((sideData) {
      return switch (sideData) {
        {
          'rotation': final int rotation,
        } =>
          rotation,
        _ => null,
      };
    }).firstWhereOrNull((rotation) => rotation != null);
    if (rotation == null) return (width: width, height: height);

    if (rotation.abs() == 90 || rotation.abs() == 270) {
      return (width: height, height: width);
    } else {
      return (width: width, height: height);
    }
  }

  /// Returns the duration of the video in milliseconds.
  int? _getDuration(MediaInformationSession session) {
    final stringDuration = session.getMediaInformation()?.getDuration();
    if (stringDuration == null) return null;

    final durationInSeconds = double.tryParse(stringDuration);
    if (durationInSeconds == null) return null;

    final durationInMilliseconds = (durationInSeconds * 1000).toInt();
    return durationInMilliseconds;
  }

  /// Analyses the videos to determine if re-encoding is required.
  void _analyseVideos() {
    // Checks if resolution is the same on all videos.
    _isResolutionSameOnAll = _videoInfos.every(
      (videoInformation) {
        if (videoInformation.width == null || videoInformation.height == null) {
          return false;
        }

        return videoInformation.width == _videoInfos.first.width &&
            videoInformation.height == _videoInfos.first.height;
      },
    );

    // Checks if format is the same on all videos.
    _isFormatSameOnAll = _videoInfos.every(
      (videoInformation) {
        if (videoInformation.format == null) return false;

        return videoInformation.format == _videoInfos.first.format;
      },
    );

    // Checks if codec is the same on all videos.
    _isCodecSameOnAll = _videoInfos.every(
      (videoInformation) {
        if (videoInformation.codec == null) return false;

        return videoInformation.codec == _videoInfos.first.codec;
      },
    );

    // Checks if frame rate is the same on all videos.
    _isFrameRateSameOnAll = _videoInfos.every(
      (videoInformation) {
        if (videoInformation.frameRate == null) return false;

        return videoInformation.frameRate == _videoInfos.first.frameRate;
      },
    );

    // Checks if audio is same on all videos.
    _isAudioSameOnAll = _videoInfos.every(
      (videoInformation) {
        final isAudioSampleRateSame = videoInformation.audioSampleRate ==
            _videoInfos.first.audioSampleRate;
        final isAudioChannelLayoutSame = videoInformation.audioChannelLayout ==
            _videoInfos.first.audioChannelLayout;

        return videoInformation.hasAudio &&
            isAudioSampleRateSame &&
            isAudioChannelLayoutSame;
      },
    );

    // Checks if re-encoding is required.
    //
    // Re-encoding is required if the resolution, format, codec, frame rate, or
    // audio is not the same on all videos.
    //
    // Re-encoding process will increase the time to merge the videos
    // significantly but will ensure that the output video is compatible with
    // all devices/players.
    _isReencodingRequired = !_isResolutionSameOnAll! ||
        !_isFormatSameOnAll! ||
        !_isCodecSameOnAll! ||
        !_isFrameRateSameOnAll! ||
        !_isAudioSameOnAll!;
  }

  Future<void> mergeVideos({required String outputDir}) async {
    if (_isReencodingRequired == null || _isAudioSameOnAll == null) {
      throw Exception('Videos are not initialised yet');
    }

    if (_videoInfos.length < 2) {
      throw Exception('At least two videos are required to merge');
    }

    final command = await _createCommand(outputDir);

    await _enableLogOnDebug();

    final session = await FFmpegKit.execute(command);

    final sessionId = session.getSessionId();

    final state = FFmpegKitConfig.sessionStateToString(
      await session.getState(),
    );
    final returnCode = await session.getReturnCode();
    final failStackTrace = await session.getFailStackTrace();

    if (returnCode?.isValueSuccess() ?? false) {
      final result = await ImageGallerySaver.saveFile(outputDir);
    }

    _dispose();
  }

  Future<String> _createCommand(String outputDir) async {
    final command = StringBuffer('-y ');

    if (_isReencodingRequired!) {
      for (final videoInformation in _videoInfos) {
        command.write('-i "${videoInformation.directory}" ');
      }

      if (!_isAudioSameOnAll!) {
        command.write('-f lavfi -t 1 -i anullsrc ');
      }

      command.write('-filter_complex "');

      final width = _videoInfos.first.width;
      final height = _videoInfos.first.height;
      final scale = _isResolutionSameOnAll! ? '' : 'scale=$width:$height,';
      final fps = _isFrameRateSameOnAll! ? '' : 'fps=30,';

      for (var i = 0; i < _videoInfos.length; i++) {
        command.write('[$i:v:0]$scale${fps}setsar=1[v$i]; ');
      }

      const audio =
          'aformat=sample_fmts=fltp:sample_rates=48000:channel_layouts=stereo'
          ',aresample=48000:first_pts=0';

      for (var i = 0; i < _videoInfos.length; i++) {
        if (_videoInfos[i].hasAudio) {
          command.write('[$i:a:0]$audio[a$i]; ');
        } else {
          command.write('[${_videoInfos.length}:a]$audio[a$i]; ');
        }
      }

      for (var i = 0; i < _videoInfos.length; i++) {
        command.write('[v$i][a$i] ');
      }

      command
        ..write('concat=n=${_videoInfos.length}:v=1:a=1[outv][outa]" ')
        ..write('-map "[outv]" -map "[outa]" ')
        ..write('-c:v libx264 -preset veryfast -crf 23 -pix_fmt yuvj420p ');

      if (!_isFrameRateSameOnAll!) {
        command.write('-fps_mode vfr ');
      }
    } else {
      // Fast concat that works only if the videos have the same resolution,
      // format, codec, frame rate and audio sample rate.
      final dirname = path.dirname(outputDir);
      final inputsDir = path.join(dirname, 'inputs.txt');
      final inputsFile = File(inputsDir);
      await inputsFile.writeAsString(
        _videoInfos
            .map((videoInformation) => "file '${videoInformation.directory}'")
            .join('\n'),
        mode: FileMode.writeOnly,
      );

      command.write('-f concat -safe 0 -i "$inputsDir" -c copy ');
    }

    command.write(outputDir);

    log(command.toString());

    return command.toString();
  }

  /// Enables progress callback to allow the user to track the progress of the
  /// FFmpeg command.
  Future<void> enableProgressCallback(ProgressCallback callback) async {
    await FFmpegKitConfig.enableStatistics();

    // Calculates the total duration of all videos.
    final totalDuration = _videoInfos.fold<int>(
      0,
      (previousValue, videoInfo) {
        return previousValue + (videoInfo.duration ?? 0);
      },
    );

    FFmpegKitConfig.enableStatisticsCallback((statistics) {
      final percentage = _calculateProgress(statistics, totalDuration);
      callback(percentage);
    });
  }

  /// Disables the progress callback.
  Future<void> disableProgressCallback() async {
    await FFmpegKitConfig.disableStatistics();
  }

  /// Calculates the progress percentage of the FFmpeg command.
  double _calculateProgress(Statistics? statistics, int totalDuration) {
    if (statistics == null) return 0;

    // The current time in the execution.
    final currentTime = statistics.getTime();

    // Calculates the progress percentage.
    final progress = (currentTime / totalDuration) * 100;

    return progress;
  }

  Future<void> _enableLogOnDebug() async {
    if (!kDebugMode) return;

    await FFmpegKitConfig.enableLogs();

    FFmpegKitConfig.enableLogCallback((log) {
      debugPrint(log.getMessage());
    });
  }

  void _dispose() {
    _videoInfos.clear();
    _isResolutionSameOnAll = null;
    _isFormatSameOnAll = null;
    _isCodecSameOnAll = null;
    _isFrameRateSameOnAll = null;
    _isAudioSameOnAll = null;
    _isReencodingRequired = null;
  }
}
