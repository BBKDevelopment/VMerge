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

  void _saveStateAsMergeSettings() {
    final settings = MergeSettings(
      isSoundOn: state.isSoundOn,
      playbackSpeed: state.playbackSpeed,
      videoResolution: state.videoResolution,
      videoAspectRatio: state.videoAspectRatio,
    );

    _saveMergeSettings(settings);
  }

  void toggleSound({required bool isSoundOn}) {
    emit(state.copyWith(isSoundOn: isSoundOn));
    _saveStateAsMergeSettings();
  }

  void changePlaybackSpeed(PlaybackSpeed playbackSpeed) {
    // Slider gets triggered multiple times when the user drags it. This check
    // prevents the settings from being saved multiple times.
    if (state.playbackSpeed == playbackSpeed) return;

    emit(state.copyWith(playbackSpeed: playbackSpeed));
    _saveStateAsMergeSettings();
  }

  void changeVideoResolution(VideoResolution videoResolution) {
    emit(state.copyWith(videoResolution: videoResolution));
    _saveStateAsMergeSettings();
  }

  void changeVideoAspectRatio(VideoAspectRatio videoAspectRatio) {
    emit(state.copyWith(videoAspectRatio: videoAspectRatio));
    _saveStateAsMergeSettings();
  }
}
