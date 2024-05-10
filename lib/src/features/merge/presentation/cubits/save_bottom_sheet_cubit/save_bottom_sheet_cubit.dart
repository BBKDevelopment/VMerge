// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ffmpeg_service/ffmpeg_service.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:wakelock_service/wakelock_service.dart';

final class SaveBottomSheetCubit extends Cubit<SaveBottomSheetState> {
  SaveBottomSheetCubit({
    required FFmpegService ffmpegService,
    required WakelockService wakelockService,
  })  : _ffmpegService = ffmpegService,
        _wakelockService = wakelockService,
        super(
          const SaveBottomSheetInitial(
            videoMetadatas: [],
          ),
        );

  final FFmpegService _ffmpegService;
  final WakelockService _wakelockService;

  void init(List<VideoMetadata> videoMetadatas) {
    emit(SaveBottomSheetInitial(videoMetadatas: videoMetadatas));
  }

  Future<void> mergeVideos({
    required bool isAudioOn,
    required double speed,
    int? outputWidth,
    int? outputHeight,
    bool? forceFirstAspectRatio,
  }) async {
    final Directory appDocsDir;
    try {
      appDocsDir = await getApplicationDocumentsDirectory();
    } catch (error, stackTrace) {
      emit(
        SaveBottomSheetError(
          errorType: SaveBottomSheetErrorType.readPermissionException,
          error: error,
          stackTrace: stackTrace,
        ),
      );
      return;
    }

    final outputVideoDir = path.join(appDocsDir.path, 'vmerge_output.mp4');
    final inputVideoDirs = (state as SaveBottomSheetInitial)
        .videoMetadatas
        .map((metadata) => metadata.file!.path)
        .toList();

    unawaited(_wakelockService.enable());

    try {
      emit(const SaveBottomSheetAnalysing());
      await Future<void>.delayed(_kMinStatusDuration);
      await _ffmpegService.initThenAnalyseVideos(inputDirs: inputVideoDirs);
      await _ffmpegService.enableProgressCallback(
        (progress) {
          if (state case SaveBottomSheetCancelled()) return;
          emit(SaveBottomSheetMerging(progress: progress.ceil()));
        },
        speed: speed,
      );
    } on FFmpegServiceInitialisationException catch (error, stackTrace) {
      emit(
        SaveBottomSheetError(
          errorType:
              SaveBottomSheetErrorType.ffmpegServiceInitialisationException,
          error: error,
          stackTrace: stackTrace,
        ),
      );
      unawaited(_wakelockService.disable());
      return;
    }

    try {
      if (state case SaveBottomSheetCancelled()) return;
      emit(const SaveBottomSheetMerging(progress: 0));
      await Future<void>.delayed(_kMinStatusDuration);
      if (state case SaveBottomSheetCancelled()) return;
      await _ffmpegService.mergeVideos(
        outputDir: outputVideoDir,
        speed: speed,
        isAudioOn: isAudioOn,
        outputWidth: outputWidth,
        outputHeight: outputHeight,
        forceFirstAspectRatio: forceFirstAspectRatio,
      );
    } on FFmpegServiceNotInitialisedException catch (error, stackTrace) {
      emit(
        SaveBottomSheetError(
          errorType:
              SaveBottomSheetErrorType.ffmpegServiceInitialisationException,
          error: error,
          stackTrace: stackTrace,
        ),
      );
      return;
    } on FFmpegServiceInsufficientVideosException catch (error, stackTrace) {
      emit(
        SaveBottomSheetError(
          errorType:
              SaveBottomSheetErrorType.ffmpegServiceInsufficientVideosException,
          error: error,
          stackTrace: stackTrace,
        ),
      );
      return;
    } on FFmpegServiceMergeException catch (error, stackTrace) {
      emit(
        SaveBottomSheetError(
          errorType: SaveBottomSheetErrorType.ffmpegServiceMergeException,
          error: error,
          stackTrace: stackTrace,
        ),
      );
      return;
    } finally {
      unawaited(_wakelockService.disable());
    }

    try {
      if (state case SaveBottomSheetCancelled()) return;
      emit(const SaveBottomSheetSaving());
      await Future<void>.delayed(_kMinStatusDuration);
      if (state case SaveBottomSheetCancelled()) return;
      await ImageGallerySaver.saveFile(outputVideoDir);
    } catch (error, stackTrace) {
      emit(
        SaveBottomSheetError(
          errorType: SaveBottomSheetErrorType.saveException,
          error: error,
          stackTrace: stackTrace,
        ),
      );
      return;
    }

    emit(const SaveBottomSheetSuccess());
  }

  Future<void> cancelMerge() async {
    if (state case SaveBottomSheetSuccess()) return;

    emit(const SaveBottomSheetCancelled());
    await _ffmpegService.cancelMerge();
  }
}

/// The minimum duration a status should be displayed for.
const _kMinStatusDuration = Duration(milliseconds: 1500);
