import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

@Entity()
final class LocalMergeSettings implements DataModel<MergeSettings> {
  LocalMergeSettings();

  LocalMergeSettings.fromArgs({
    required this.isSoundOn,
    required this.playbackSpeed,
    required this.videoResolution,
    required this.videoAspectRatio,
  });

  LocalMergeSettings.fromEntity(MergeSettings entity)
      : this.fromArgs(
          isSoundOn: entity.isSoundOn,
          playbackSpeed: entity.playbackSpeed.toString(),
          videoResolution: entity.videoResolution.toString(),
          videoAspectRatio: entity.videoAspectRatio.toString(),
        );

  int id = 0;
  bool isSoundOn = false;
  String playbackSpeed = '';
  String videoResolution = '';
  String videoAspectRatio = '';

  @override
  MergeSettings toEntity() {
    return MergeSettings(
      isSoundOn: isSoundOn,
      playbackSpeed: PlaybackSpeed.fromString(playbackSpeed),
      videoResolution: VideoResolution.fromString(videoResolution),
      videoAspectRatio: VideoAspectRatio.fromString(videoAspectRatio),
    );
  }
}
