import 'package:equatable/equatable.dart';
import 'package:vmerge/src/features/merge/domain/domain.dart';

sealed class SaveBottomSheetState extends Equatable {
  const SaveBottomSheetState();
}

final class SaveBottomSheetInitial extends SaveBottomSheetState {
  const SaveBottomSheetInitial({required this.videoMetadatas});

  final List<VideoMetadata> videoMetadatas;

  @override
  List<Object?> get props => [videoMetadatas];
}

final class SaveBottomSheetAnalysing extends SaveBottomSheetState {
  const SaveBottomSheetAnalysing();

  @override
  List<Object?> get props => [];
}

final class SaveBottomSheetMerging extends SaveBottomSheetState {
  const SaveBottomSheetMerging({
    required this.progress,
  });

  final int progress;

  SaveBottomSheetMerging copyWith({
    int? progress,
  }) {
    return SaveBottomSheetMerging(
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [progress];
}

final class SaveBottomSheetSaving extends SaveBottomSheetState {
  const SaveBottomSheetSaving();

  @override
  List<Object?> get props => [];
}

final class SaveBottomSheetSuccess extends SaveBottomSheetState {
  const SaveBottomSheetSuccess();

  @override
  List<Object?> get props => [];
}

final class SaveBottomSheetError extends SaveBottomSheetState {
  const SaveBottomSheetError({
    required this.errorType,
    required this.error,
    required this.stackTrace,
  });

  final SaveBottomSheetErrorType errorType;
  final Object error;
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [
        errorType,
        error,
        stackTrace,
      ];
}

enum SaveBottomSheetErrorType {
  readPermissionException,
  ffmpegServiceInitialisationException,
  ffmpegServiceInsufficientVideosException,
  ffmpegServiceMergeException,
  saveException,
}
