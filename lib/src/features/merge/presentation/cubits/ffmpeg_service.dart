import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:get/utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:vmerge/src/features/merge/presentation/cubits/video_information.dart';

final class FFmpegService {
  FFmpegService()
      : _videoInformations = List.empty(growable: true),
        _isAudioSameOnAll = null,
        _isReencodingRequired = null;

  static const _typeVideo = 'VIDEO';
  static const _typeAudio = 'AUDIO';

  final List<VideoInformation> _videoInformations;
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
          (stream) => stream.getType()?.toUpperCase() == _typeVideo,
        );
    final audioStream = mediaInformationSession
        .getMediaInformation()
        ?.getStreams()
        .firstWhereOrNull(
          (stream) => stream.getType()?.toUpperCase() == _typeAudio,
        );
    final videoInformation = VideoInformation(
      directory: dir,
      width: videoStream?.getWidth(),
      height: videoStream?.getHeight(),
      format: mediaInformationSession.getMediaInformation()?.getFormat(),
      codec: videoStream?.getCodec(),
      frameRate: videoStream?.getRealFrameRate(),
      hasAudio: audioStream != null,
      audioSampleRate: audioStream?.getSampleRate(),
      audioChannelLayout: audioStream?.getChannelLayout(),
    );
    _videoInformations.add(videoInformation);
  }

  /// Analyses the videos to determine if re-encoding is required and if audio
  /// is available for all videos.
  void _analyseVideos() {
    // Checks if resolution is the same on all videos.
    _isResolutionSameOnAll = _videoInformations.every(
      (videoInformation) {
        if (videoInformation.width == null || videoInformation.height == null) {
          return false;
        }

        return videoInformation.width == _videoInformations.first.width &&
            videoInformation.height == _videoInformations.first.height;
      },
    );

    // Checks if format is the same on all videos.
    _isFormatSameOnAll = _videoInformations.every(
      (videoInformation) {
        if (videoInformation.format == null) return false;

        return videoInformation.format == _videoInformations.first.format;
      },
    );

    // Checks if codec is the same on all videos.
    _isCodecSameOnAll = _videoInformations.every(
      (videoInformation) {
        if (videoInformation.codec == null) return false;

        return videoInformation.codec == _videoInformations.first.codec;
      },
    );

    // Checks if frame rate is the same on all videos.
    _isFrameRateSameOnAll = _videoInformations.every(
      (videoInformation) {
        if (videoInformation.frameRate == null) return false;

        return videoInformation.frameRate == _videoInformations.first.frameRate;
      },
    );

    // Checks if audio is same on all videos.
    _isAudioSameOnAll = _videoInformations.every(
      (videoInformation) {
        final isAudioSampleRateSame = videoInformation.audioSampleRate ==
            _videoInformations.first.audioSampleRate;
        final isAudioChannelLayoutSame = videoInformation.audioChannelLayout ==
            _videoInformations.first.audioChannelLayout;

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

    if (_videoInformations.length < 2) {
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

    if (ReturnCode.isCancel(returnCode)) {
      print('cancelled');
    } else {
      print('done');
      final result = await ImageGallerySaver.saveFile(outputDir);
      print(result);
    }

    _dispose();
  }

  Future<String> _createCommand(String outputDir) async {
    final command = StringBuffer('-y ');

    if (_isReencodingRequired!) {
      for (final videoInformation in _videoInformations) {
        command.write('-i "${videoInformation.directory}" ');
      }

      if (!_isAudioSameOnAll!) {
        command.write('-f lavfi -t 1 -i anullsrc ');
      }

      command.write('-filter_complex "');

      final width = _videoInformations.first.width;
      final height = _videoInformations.first.height;
      final scale = _isResolutionSameOnAll! ? '' : 'scale=$width:$height,';
      final fps = _isFrameRateSameOnAll! ? '' : 'fps=30,';

      for (var i = 0; i < _videoInformations.length; i++) {
        command.write('[$i:v:0]$scale${fps}setsar=1[v$i]; ');
      }

      final audio = _isAudioSameOnAll!
          ? ''
          : 'aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo'
              ',aresample=44100';

      for (var i = 0; i < _videoInformations.length; i++) {
        if (_videoInformations[i].hasAudio) {
          command.write('[$i:a:0]$audio[a$i]; ');
        } else {
          command.write('[${_videoInformations.length}:a]$audio[a$i]; ');
        }
      }

      for (var i = 0; i < _videoInformations.length; i++) {
        command.write('[v$i][a$i] ');
      }

      command
        ..write('concat=n=${_videoInformations.length}:v=1:a=1[outv][outa]; ')
        ..write('[outv]setsar=1[outv]" -map "[outv]" -map "[outa]" ')
        ..write('-c:v libx264 -preset veryfast -crf 23 -pix_fmt yuv420p ');

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
        _videoInformations
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

  Future<void> _enableLogOnDebug() async {
    if (!kDebugMode) return;

    await FFmpegKitConfig.enableLogs();

    FFmpegKitConfig.enableLogCallback((log) {
      debugPrint(log.getMessage());
    });
  }

  void _dispose() {
    _videoInformations.clear();
    _isResolutionSameOnAll = null;
    _isFormatSameOnAll = null;
    _isCodecSameOnAll = null;
    _isFrameRateSameOnAll = null;
    _isAudioSameOnAll = null;
    _isReencodingRequired = null;
  }
}
