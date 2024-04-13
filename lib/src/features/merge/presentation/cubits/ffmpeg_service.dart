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
import 'package:path/path.dart' as path;
import 'package:vmerge/src/features/merge/presentation/cubits/video_detail.dart';

/// An exception thrown when the FFmpeg service fails to initialise.
final class FFmpegServiceInitialisationException implements Exception {
  const FFmpegServiceInitialisationException();
}

/// An exception thrown when the FFmpeg service is not initialised.
final class FFmpegServiceNotInitialisedException implements Exception {
  const FFmpegServiceNotInitialisedException();
}

/// An exception thrown when there are insufficient videos to merge.
final class FFmpegServiceInsufficientVideosException implements Exception {
  const FFmpegServiceInsufficientVideosException();
}

/// An exception thrown when the FFmpeg service fails to merge the videos.
final class FFmpegServiceMergeException implements Exception {
  const FFmpegServiceMergeException();
}

/// Callback to report the progress of the FFmpeg command.
typedef ProgressCallback = void Function(double progress);

final class FFmpegService {
  FFmpegService()
      : _videoDetails = List.empty(growable: true),
        _isAudioSameOnAll = null,
        _isReencodingRequired = null;

  final List<VideoDetail> _videoDetails;
  bool? _isResolutionSameOnAll;
  bool? _isFormatSameOnAll;
  bool? _isCodecSameOnAll;
  bool? _isFrameRateSameOnAll;
  bool? _isAudioSameOnAll;
  bool? _isReencodingRequired;

  /// Initialises the FFmpeg service and analyses the videos to determine if
  /// re-encoding is required.
  ///
  /// Throws [FFmpegServiceInitialisationException] if the FFmpeg service fails
  /// to initialise.
  Future<void> initThenAnalyseVideos({required List<String> inputDirs}) async {
    // Disposes the previous state.
    _dispose();

    for (final inputDir in inputDirs) {
      try {
        await _initVideo(inputDir);
      } catch (_) {
        throw const FFmpegServiceNotInitialisedException();
      }
    }

    // Analyse the videos to determine if re-encoding is required and if audio
    // is available for all videos.
    _analyseVideos();
  }

  /// Initialises the video and extracts the video details.
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
    final videoDetail = VideoDetail(
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
    _videoDetails.add(videoDetail);
  }

  /// Checks if the video is rotated and returns the video width and height
  /// based on the rotation.
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
    _isResolutionSameOnAll = _videoDetails.every(
      (videoDetail) {
        if (videoDetail.width == null || videoDetail.height == null) {
          return false;
        }

        return videoDetail.width == _videoDetails.first.width &&
            videoDetail.height == _videoDetails.first.height;
      },
    );

    // Checks if format is the same on all videos.
    _isFormatSameOnAll = _videoDetails.every(
      (videoInformation) {
        if (videoInformation.format == null) return false;

        return videoInformation.format == _videoDetails.first.format;
      },
    );

    // Checks if codec is the same on all videos.
    _isCodecSameOnAll = _videoDetails.every(
      (videoInformation) {
        if (videoInformation.codec == null) return false;

        return videoInformation.codec == _videoDetails.first.codec;
      },
    );

    // Checks if frame rate is the same on all videos.
    _isFrameRateSameOnAll = _videoDetails.every(
      (videoInformation) {
        if (videoInformation.frameRate == null) return false;

        return videoInformation.frameRate == _videoDetails.first.frameRate;
      },
    );

    // Checks if audio is same on all videos.
    _isAudioSameOnAll = _videoDetails.every(
      (videoInformation) {
        final isAudioSampleRateSame = videoInformation.audioSampleRate ==
            _videoDetails.first.audioSampleRate;
        final isAudioChannelLayoutSame = videoInformation.audioChannelLayout ==
            _videoDetails.first.audioChannelLayout;

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

  /// Merges the videos.
  ///
  /// Throws [FFmpegServiceNotInitialisedException] if the FFmpeg service is not
  /// initialised.
  ///
  /// Throws [FFmpegServiceInsufficientVideosException] if there are less than 2
  /// videos to merge.
  ///
  /// Throws [FFmpegServiceMergeException] if the FFmpeg service fails to merge
  /// the videos.
  Future<void> mergeVideos({required String outputDir}) async {
    if (_isReencodingRequired == null || _isAudioSameOnAll == null) {
      throw const FFmpegServiceNotInitialisedException();
    }

    if (_videoDetails.length < 2) {
      throw const FFmpegServiceInsufficientVideosException();
    }

    final command = await _createCommand(outputDir);

    await _enableLogOnDebug();

    try {
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      final isSuccess = returnCode?.isValueSuccess() ?? false;
      if (!isSuccess) throw Exception('Failed to merge videos');
    } catch (_) {
      throw const FFmpegServiceMergeException();
    } finally {
      _dispose();
    }
  }

  /// Creates the FFmpeg command to merge the videos.
  Future<String> _createCommand(String outputDir) async {
    final command = StringBuffer('-y ');

    if (_isReencodingRequired!) {
      for (final videoInformation in _videoDetails) {
        command.write('-i "${videoInformation.directory}" ');
      }

      if (!_isAudioSameOnAll!) {
        command.write('-f lavfi -t 1 -i anullsrc ');
      }

      command.write('-filter_complex "');

      final width = _videoDetails.first.width;
      final height = _videoDetails.first.height;
      final scale = _isResolutionSameOnAll! ? '' : 'scale=$width:$height,';
      final fps = _isFrameRateSameOnAll! ? '' : 'fps=30,';

      for (var i = 0; i < _videoDetails.length; i++) {
        command.write('[$i:v:0]$scale${fps}setsar=1[v$i]; ');
      }

      const audio =
          'aformat=sample_fmts=fltp:sample_rates=48000:channel_layouts=stereo'
          ',aresample=48000:first_pts=0';

      for (var i = 0; i < _videoDetails.length; i++) {
        if (_videoDetails[i].hasAudio) {
          command.write('[$i:a:0]$audio[a$i]; ');
        } else {
          command.write('[${_videoDetails.length}:a]$audio[a$i]; ');
        }
      }

      for (var i = 0; i < _videoDetails.length; i++) {
        command.write('[v$i][a$i] ');
      }

      command
        ..write('concat=n=${_videoDetails.length}:v=1:a=1[outv][outa]" ')
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
        _videoDetails
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

  /// Enables progress callback to allow the consumer of this service to get the
  /// progress of the FFmpeg command.
  Future<void> enableProgressCallback(ProgressCallback callback) async {
    await FFmpegKitConfig.enableStatistics();

    // Calculates the total duration of all videos.
    final totalDuration = _videoDetails.fold<int>(
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

  /// Enables logs and log callback for debugging purposes.
  Future<void> _enableLogOnDebug() async {
    if (!kDebugMode) return;

    try {
      await FFmpegKitConfig.enableLogs();

      FFmpegKitConfig.enableLogCallback((ffmpegLog) {
        log(ffmpegLog.getMessage());
      });
    } catch (error, stackTrace) {
      log(
        'Could not enable logs!',
        name: '$FFmpegService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Disposes the resources.
  void _dispose() {
    _videoDetails.clear();
    _isResolutionSameOnAll = null;
    _isFormatSameOnAll = null;
    _isCodecSameOnAll = null;
    _isFrameRateSameOnAll = null;
    _isAudioSameOnAll = null;
    _isReencodingRequired = null;
  }
}
