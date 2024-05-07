import 'package:equatable/equatable.dart';
import 'package:vmerge/src/features/merge/merge.dart';

sealed class SettingsBottomSheetState extends Equatable {
  const SettingsBottomSheetState();
}

final class SettingsBottomSheetInitial extends SettingsBottomSheetState {
  const SettingsBottomSheetInitial();

  @override
  List<Object?> get props => [];
}

final class SettingsBottomSheetLoading extends SettingsBottomSheetState {
  const SettingsBottomSheetLoading();

  @override
  List<Object?> get props => [];
}

final class SettingsBottomSheetLoaded extends SettingsBottomSheetState {
  const SettingsBottomSheetLoaded({
    required this.isSoundOn,
    required this.playbackSpeed,
    required this.videoResolution,
    required this.videoAspectRatio,
  });

  final bool isSoundOn;
  final PlaybackSpeed playbackSpeed;
  final VideoResolution videoResolution;
  final VideoAspectRatio videoAspectRatio;

  SettingsBottomSheetLoaded copyWith({
    bool? isSoundOn,
    PlaybackSpeed? playbackSpeed,
    VideoResolution? videoResolution,
    VideoAspectRatio? videoAspectRatio,
  }) {
    return SettingsBottomSheetLoaded(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      videoResolution: videoResolution ?? this.videoResolution,
      videoAspectRatio: videoAspectRatio ?? this.videoAspectRatio,
    );
  }

  @override
  List<Object?> get props => [
        isSoundOn,
        playbackSpeed,
        videoResolution,
        videoAspectRatio,
      ];
}

final class SettingsBottomSheetError extends SettingsBottomSheetState {
  const SettingsBottomSheetError({
    required this.errorType,
    required this.error,
    required this.stackTrace,
  });

  final SettingsBottomSheetErrorType errorType;
  final Object error;
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [
        errorType,
        error,
        stackTrace,
      ];
}

enum SettingsBottomSheetErrorType {
  saveSettingsException,
}
