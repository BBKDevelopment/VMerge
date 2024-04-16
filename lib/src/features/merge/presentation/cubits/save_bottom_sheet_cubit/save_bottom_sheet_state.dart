import 'package:equatable/equatable.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class SaveBottomSheetState extends Equatable {
  const SaveBottomSheetState({
    required this.videoMetadatas,
    required this.status,
    required this.progress,
  });

  final List<VideoMetadata> videoMetadatas;
  final SaveBottomSheetStatus status;
  final int progress;

  SaveBottomSheetState copyWith({
    List<VideoMetadata>? videoMetadatas,
    SaveBottomSheetStatus? status,
    int? progress,
  }) {
    return SaveBottomSheetState(
      videoMetadatas: videoMetadatas ?? this.videoMetadatas,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [videoMetadatas, status, progress];
}

enum SaveBottomSheetStatus {
  analyse,
  merge,
  save,
  success,
  error,
}
