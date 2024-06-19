// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ffmpeg_service/ffmpeg_service.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:in_app_review_service/in_app_review_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:wakelock_service/wakelock_service.dart';

final class SaveBottomSheetCubit extends Cubit<SaveBottomSheetState> {
  SaveBottomSheetCubit({
    required FFmpegService ffmpegService,
    required WakelockService wakelockService,
    required InAppReviewService inAppReviewService,
    required GetMergeStatisticsUseCase getMergeStatisticsUseCase,
    required SaveMergeStatisticsUseCase saveMergeStatisticsUseCase,
  })  : _ffmpegService = ffmpegService,
        _wakelockService = wakelockService,
        _getMergeStatisticsUseCase = getMergeStatisticsUseCase,
        _saveMergeStatisticsUseCase = saveMergeStatisticsUseCase,
        _inAppReviewService = inAppReviewService,
        super(
          const SaveBottomSheetInitial(
            videoMetadatas: [],
          ),
        );

  final FFmpegService _ffmpegService;
  final WakelockService _wakelockService;
  final InAppReviewService _inAppReviewService;
  final GetMergeStatisticsUseCase _getMergeStatisticsUseCase;
  final SaveMergeStatisticsUseCase _saveMergeStatisticsUseCase;

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
          statistics?.copyWith(
            failedMergeCount: statistics.failedMergeCount + 1,
          ),
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
          statistics?.copyWith(
            failedMergeCount: statistics.failedMergeCount + 1,
          ),
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
          statistics?.copyWith(
            failedMergeCount: statistics.failedMergeCount + 1,
          ),
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
          statistics?.copyWith(
            failedMergeCount: statistics.failedMergeCount + 1,
          ),
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
          statistics?.copyWith(
            failedMergeCount: statistics.failedMergeCount + 1,
          ),
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
          statistics?.copyWith(
            failedMergeCount: statistics.failedMergeCount + 1,
          ),
        ),
      );
      return;
    }

    final newStatistics = statistics?.copyWith(
      successMergeCount: statistics.successMergeCount + 1,
    );
    unawaited(_saveMergeStatistics(newStatistics));
    unawaited(_requestReview(newStatistics));
    emit(const SaveBottomSheetSuccess());
  }

  Future<void> cancelMerge() async {
    if (state case SaveBottomSheetSuccess()) return;

    emit(const SaveBottomSheetCancelled());
    await _ffmpegService.cancelMerge();
  }

  Future<MergeStatistics?> _getMergeStatistics() async {
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
        return null;
    }
  }

  Future<void> _saveMergeStatistics(MergeStatistics? statistics) async {
    if (statistics == null) return;

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

  Future<void> _requestReview(MergeStatistics? statistics) async {
    if (statistics == null) return;

    final totalMergeCount =
        statistics.successMergeCount + statistics.failedMergeCount;
    // If the user has not merged at least 2 videos, don't request review.
    if (totalMergeCount < 2) return;

    final successRate = statistics.successMergeCount / totalMergeCount;
    // If the success rate is less than 90%, don't request review.
    if (successRate < 0.9) return;

    try {
      await _inAppReviewService.requestReview();
    } on RequestReviewException catch (error, stackTrace) {
      log(
        'Could not request review!',
        name: '$SaveBottomSheetCubit',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// The minimum duration a status should be displayed for.
const _kMinStatusDuration = Duration(milliseconds: 1500);
