import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class SettingsModalBottomSheetCubit
    extends Cubit<SettingsModalBottomSheetState> {
  SettingsModalBottomSheetCubit({
    required GetMergeSettingsUseCase getMergeSettingsUseCase,
    required SaveMergeSettingsUseCase saveMergeSettingsUseCase,
  })  : _getMergeSettingsUseCase = getMergeSettingsUseCase,
        _saveMergeSettingsUseCase = saveMergeSettingsUseCase,
        super(
          SettingsModalBottomSheetState(
            isSoundOn: _defaultMergeSettings.isSoundOn,
            playbackSpeed: _defaultMergeSettings.playbackSpeed,
            videoResolution: _defaultMergeSettings.videoResolution,
            videoAspectRatio: _defaultMergeSettings.videoAspectRatio,
          ),
        );

  final GetMergeSettingsUseCase _getMergeSettingsUseCase;
  final SaveMergeSettingsUseCase _saveMergeSettingsUseCase;

  static const _defaultMergeSettings = MergeSettings(
    isSoundOn: true,
    playbackSpeed: PlaybackSpeed.one,
    videoResolution: VideoResolution.original,
    videoAspectRatio: VideoAspectRatio.independent,
  );

  Future<void> init() async {
    final settings = await _getMergeSettings();

    emit(
      state.copyWith(
        isSoundOn: settings.isSoundOn,
        playbackSpeed: settings.playbackSpeed,
        videoResolution: settings.videoResolution,
        videoAspectRatio: settings.videoAspectRatio,
      ),
    );
  }

  Future<MergeSettings> _getMergeSettings() async {
    final response = await _getMergeSettingsUseCase();

    switch (response) {
      case final DataSuccess<MergeSettings> success:
        return success.data;
      case final DataFailure<MergeSettings> failure:
        log(
          failure.message,
          name: failure.name,
          error: failure.error,
          stackTrace: failure.stackTrace,
        );
        await _saveMergeSettings(_defaultMergeSettings);
        return _defaultMergeSettings;
    }
  }

  Future<void> _saveMergeSettings(MergeSettings settings) async {
    final response = await _saveMergeSettingsUseCase(params: settings);

    switch (response) {
      case DataSuccess():
        return;
      case final DataFailure<bool> failure:
        log(
          failure.message,
          name: failure.name,
          error: failure.error,
          stackTrace: failure.stackTrace,
        );
    }
  }

  void toggleSound({required bool isSoundOn}) {
    emit(state.copyWith(isSoundOn: isSoundOn));
  }

  void changePlaybackSpeed(PlaybackSpeed playbackSpeed) {
    emit(state.copyWith(playbackSpeed: playbackSpeed));
  }

  void changeVideoResolution(VideoResolution videoResolution) {
    emit(state.copyWith(videoResolution: videoResolution));
  }

  void changeVideoAspectRatio(VideoAspectRatio videoAspectRatio) {
    emit(state.copyWith(videoAspectRatio: videoAspectRatio));
  }
}
