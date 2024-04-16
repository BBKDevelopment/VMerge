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
  SaveBottomSheetCubit()
      : super(
          const SaveBottomSheetState(
            videoMetadatas: [],
            status: SaveBottomSheetStatus.analyse,
            progress: 0,
          ),
        );

  final FFmpegService _ffmpegService = FFmpegService();
  final WakelockService _wakelockService = WakelockService();

  void init(List<VideoMetadata> videoMetadatas) {
    emit(state.copyWith(videoMetadatas: videoMetadatas));
  }

  Future<void> mergeVideos() async {
    final Directory appDocsDir;
    try {
      appDocsDir = await getApplicationDocumentsDirectory();
    } catch (_) {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    }

    final outputVideoDir = path.join(appDocsDir.path, 'vmerge_output.mp4');
    final inputVideoDirs =
        state.videoMetadatas.map((metadata) => metadata.file!.path).toList();

    unawaited(_wakelockService.enable());

    try {
      emit(state.copyWith(status: SaveBottomSheetStatus.analyse));
      await _ffmpegService.initThenAnalyseVideos(inputDirs: inputVideoDirs);
      await _ffmpegService.enableProgressCallback((progress) {
        emit(state.copyWith(progress: progress.ceil()));
      });
      await Future<void>.delayed(_kMinStatusDuration);
    } on FFmpegServiceInitialisationException {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      unawaited(_wakelockService.disable());
      return;
    }

    try {
      emit(state.copyWith(status: SaveBottomSheetStatus.merge));
      await _ffmpegService.mergeVideos(outputDir: outputVideoDir);
      await Future<void>.delayed(_kMinStatusDuration);
    } on FFmpegServiceNotInitialisedException {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    } on FFmpegServiceInsufficientVideosException {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    } on FFmpegServiceMergeException {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    } finally {
      unawaited(_wakelockService.disable());
    }

    try {
      emit(state.copyWith(status: SaveBottomSheetStatus.save, progress: 100));
      await ImageGallerySaver.saveFile(outputVideoDir);
      await Future<void>.delayed(_kMinStatusDuration);
    } catch (_) {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    }

    emit(state.copyWith(status: SaveBottomSheetStatus.success));
  }
}

/// The minimum duration a status should be displayed for.
const _kMinStatusDuration = Duration(milliseconds: 1500);
