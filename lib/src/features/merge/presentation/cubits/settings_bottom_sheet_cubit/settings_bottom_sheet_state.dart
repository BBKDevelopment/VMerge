import 'package:equatable/equatable.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class SettingsBottomSheetState extends Equatable {
  const SettingsBottomSheetState({
    required this.isSoundOn,
    required this.playbackSpeed,
    required this.videoResolution,
    required this.videoAspectRatio,
  });

  final bool isSoundOn;
  final PlaybackSpeed playbackSpeed;
  final VideoResolution videoResolution;
  final VideoAspectRatio videoAspectRatio;

  SettingsBottomSheetState copyWith({
    bool? isSoundOn,
    PlaybackSpeed? playbackSpeed,
    VideoResolution? videoResolution,
    VideoAspectRatio? videoAspectRatio,
  }) {
    return SettingsBottomSheetState(
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
