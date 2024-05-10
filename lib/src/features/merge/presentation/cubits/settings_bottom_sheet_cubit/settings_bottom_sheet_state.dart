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
    required this.isAudioOn,
    required this.playbackSpeed,
    required this.videoResolution,
    required this.videoAspectRatio,
  });

  final bool isAudioOn;
  final PlaybackSpeed playbackSpeed;
  final VideoResolution videoResolution;
  final VideoAspectRatio videoAspectRatio;

  SettingsBottomSheetLoaded copyWith({
    bool? isAudioOn,
    PlaybackSpeed? playbackSpeed,
    VideoResolution? videoResolution,
    VideoAspectRatio? videoAspectRatio,
  }) {
    return SettingsBottomSheetLoaded(
      isAudioOn: isAudioOn ?? this.isAudioOn,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      videoResolution: videoResolution ?? this.videoResolution,
      videoAspectRatio: videoAspectRatio ?? this.videoAspectRatio,
    );
  }

  @override
  List<Object?> get props => [
        isAudioOn,
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
