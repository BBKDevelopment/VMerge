import 'package:bloc/bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:vmerge/src/features/merge/presentation/cubits/ffmpeg_service.dart';

class SaveBottomSheetCubit extends Cubit<SaveBottomSheetState> {
  SaveBottomSheetCubit()
      : super(
          const SaveBottomSheetState(
            videoMetadatas: [],
            status: SaveBottomSheetStatus.analyse,
            progress: 0,
          ),
        );

  final FFmpegService _ffmpegService = FFmpegService();

  void init(List<VideoMetadata> videoMetadatas) {
    emit(state.copyWith(videoMetadatas: videoMetadatas));
  }

  Future<void> mergeVideos() async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final outputVideoDir = path.join(appDocsDir.path, 'vmerge_output.mp4');
    final inputVideoDirs =
        state.videoMetadatas.map((metadata) => metadata.file!.path).toList();

    try {
      emit(state.copyWith(status: SaveBottomSheetStatus.analyse));
      await _ffmpegService.initThenAnalyseVideos(inputDirs: inputVideoDirs);
      await _ffmpegService.enableProgressCallback((progress) {
        emit(state.copyWith(progress: progress.ceil()));
      });
      await Future<void>.delayed(const Duration(seconds: 1));
    } on FFmpegServiceInitialisationException {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    }

    try {
      emit(state.copyWith(status: SaveBottomSheetStatus.merge));
      await _ffmpegService.mergeVideos(outputDir: outputVideoDir);
      await Future<void>.delayed(const Duration(seconds: 1));
    } on FFmpegServiceNotInitialisedException {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    } on FFmpegServiceInsufficientVideosException {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    } on FFmpegServiceMergeException {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    }

    try {
      emit(state.copyWith(status: SaveBottomSheetStatus.save));
      await ImageGallerySaver.saveFile(outputVideoDir);
      await Future<void>.delayed(const Duration(seconds: 1));
    } catch (_) {
      emit(state.copyWith(status: SaveBottomSheetStatus.error));
      return;
    }

    emit(state.copyWith(status: SaveBottomSheetStatus.success));
  }
}