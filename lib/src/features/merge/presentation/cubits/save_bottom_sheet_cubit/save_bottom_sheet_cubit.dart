// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ffmpeg_service/ffmpeg_service.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:wakelock_service/wakelock_service.dart';

final class SaveBottomSheetCubit extends Cubit<SaveBottomSheetState> {
  SaveBottomSheetCubit({
    required FFmpegService ffmpegService,
    required WakelockService wakelockService,
    required GetMergeStatisticsUseCase getMergeStatisticsUseCase,
    required SaveMergeStatisticsUseCase saveMergeStatisticsUseCase,
  })  : _ffmpegService = ffmpegService,
        _wakelockService = wakelockService,
        _getMergeStatisticsUseCase = getMergeStatisticsUseCase,
        _saveMergeStatisticsUseCase = saveMergeStatisticsUseCase,
        super(
          const SaveBottomSheetInitial(
            videoMetadatas: [],
          ),
        );

  final FFmpegService _ffmpegService;
  final WakelockService _wakelockService;
  final GetMergeStatisticsUseCase _getMergeStatisticsUseCase;
  final SaveMergeStatisticsUseCase _saveMergeStatisticsUseCase;

  static const _defaultMergeStatistics = MergeStatistics(
    successMerges: 0,
    failedMerges: 0,
  );

  Future<void> init(List<VideoMetadata> videoMetadatas) async {
    emit(SaveBottomSheetInitial(videoMetadatas: videoMetadatas));
  }

  Future<void> mergeVideos({
    required bool isAudioOn,
    required double speed,
    int? outputWidth,
    int? outputHeight,
    bool? forceFirstAspectRatio,
  }) async {
    final statistics = await _getMergeStatistics();

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
      unawaited(
        _saveMergeStatistics(
          statistics.copyWith(failedMerges: statistics.failedMerges + 1),
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
      unawaited(
        _saveMergeStatistics(
          statistics.copyWith(failedMerges: statistics.failedMerges + 1),
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
      unawaited(
        _saveMergeStatistics(
          statistics.copyWith(failedMerges: statistics.failedMerges + 1),
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
      unawaited(
        _saveMergeStatistics(
          statistics.copyWith(failedMerges: statistics.failedMerges + 1),
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
      unawaited(
        _saveMergeStatistics(
          statistics.copyWith(failedMerges: statistics.failedMerges + 1),
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
      unawaited(
        _saveMergeStatistics(
          statistics.copyWith(failedMerges: statistics.failedMerges + 1),
        ),
      );
      return;
    }

    emit(const SaveBottomSheetSuccess());
    unawaited(
      _saveMergeStatistics(
        statistics.copyWith(successMerges: statistics.successMerges + 1),
      ),
    );
  }

  Future<void> cancelMerge() async {
    if (state case SaveBottomSheetSuccess()) return;

    emit(const SaveBottomSheetCancelled());
    await _ffmpegService.cancelMerge();
  }

  Future<MergeStatistics> _getMergeStatistics() async {
    final dataState = await _getMergeStatisticsUseCase();

    switch (dataState) {
      case DataSuccess():
        return dataState.data;
      case DataFailure():
        log(
          dataState.message,
          name: dataState.name,
          error: dataState.error,
          stackTrace: dataState.stackTrace,
        );
        await _saveMergeStatistics(_defaultMergeStatistics);
        return _defaultMergeStatistics;
    }
  }

  Future<void> _saveMergeStatistics(MergeStatistics statistics) async {
    final dataState = await _saveMergeStatisticsUseCase(params: statistics);

    switch (dataState) {
      case DataSuccess():
        break;
      case DataFailure():
        log(
          dataState.message,
          name: dataState.name,
          error: dataState.error,
          stackTrace: dataState.stackTrace,
        );
    }
  }
}

/// The minimum duration a status should be displayed for.
const _kMinStatusDuration = Duration(milliseconds: 1500);
