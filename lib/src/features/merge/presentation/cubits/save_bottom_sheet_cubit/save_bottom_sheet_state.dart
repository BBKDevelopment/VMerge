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
    required this.type,
    required this.error,
    required this.stackTrace,
  });

  final SaveBottomSheetErrorType type;
  final Object error;
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [
        type,
        error,
        stackTrace,
      ];
}

enum SaveBottomSheetErrorType {
  readPermissionException,
  videoInitialisationException,
  insufficientVideoException,
  mergeException,
  saveException,
}

// final class SaveBottomSheetState extends Equatable {
//   const SaveBottomSheetState({
//     required this.videoMetadatas,
//     required this.status,
//     required this.progress,
//   });
//
//   final List<VideoMetadata> videoMetadatas;
//   final SaveBottomSheetStatus status;
//   final int progress;
//
//   SaveBottomSheetState copyWith({
//     List<VideoMetadata>? videoMetadatas,
//     SaveBottomSheetStatus? status,
//     int? progress,
//   }) {
//     return SaveBottomSheetState(
//       videoMetadatas: videoMetadatas ?? this.videoMetadatas,
//       status: status ?? this.status,
//       progress: progress ?? this.progress,
//     );
//   }
//
//   @override
//   List<Object?> get props => [videoMetadatas, status, progress];
// }
//
// enum SaveBottomSheetStatus {
//   analyse,
//   merge,
//   save,
//   success,
//   error,
// }
