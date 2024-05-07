import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class SettingsBottomSheetCubit extends Cubit<SettingsBottomSheetState> {
  SettingsBottomSheetCubit({
    required GetMergeSettingsUseCase getMergeSettingsUseCase,
    required SaveMergeSettingsUseCase saveMergeSettingsUseCase,
  })  : _getMergeSettingsUseCase = getMergeSettingsUseCase,
        _saveMergeSettingsUseCase = saveMergeSettingsUseCase,
        super(
          SettingsBottomSheetLoaded(
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
      SettingsBottomSheetLoaded(
        isSoundOn: settings.isSoundOn,
        playbackSpeed: settings.playbackSpeed,
        videoResolution: settings.videoResolution,
        videoAspectRatio: settings.videoAspectRatio,
      ),
    );
  }

  Future<MergeSettings> _getMergeSettings() async {
    final dataState = await _getMergeSettingsUseCase();

    switch (dataState) {
      case DataSuccess():
        return dataState.data;
      case DataFailure():
        log(
          dataState.message,
          name: dataState.name,
          error: dataState.error,
          stackTrace: dataState.stackTrace,
        );
        await _saveMergeSettings(_defaultMergeSettings);
        return _defaultMergeSettings;
    }
  }

  Future<void> _saveMergeSettings(MergeSettings settings) async {
    final dataState = await _saveMergeSettingsUseCase(params: settings);

    switch (dataState) {
      case DataSuccess():
        break;
      case DataFailure():
        log(
          dataState.message,
          name: dataState.name,
          error: dataState.error,
          stackTrace: dataState.stackTrace,
        );
        final recoveryState = state;
        emit(
          SettingsBottomSheetError(
            errorType: SettingsBottomSheetErrorType.saveSettingsException,
            error: dataState.error,
            stackTrace: dataState.stackTrace,
          ),
        );
        emit(recoveryState);
    }
  }

  void _saveStateAsMergeSettings() {
    if (state case final SettingsBottomSheetLoaded loadedState) {
      final settings = MergeSettings(
        isSoundOn: loadedState.isSoundOn,
        playbackSpeed: loadedState.playbackSpeed,
        videoResolution: loadedState.videoResolution,
        videoAspectRatio: loadedState.videoAspectRatio,
      );
      _saveMergeSettings(settings);
    }
  }

  void toggleSound({required bool isSoundOn}) {
    if (state case final SettingsBottomSheetLoaded loadedState) {
      emit(loadedState.copyWith(isSoundOn: isSoundOn));
      _saveStateAsMergeSettings();
    }
  }

  void changePlaybackSpeed(PlaybackSpeed playbackSpeed) {
    if (state case final SettingsBottomSheetLoaded loadedState) {
      // Slider gets triggered multiple times when the user drags it. This
      // check prevents the settings from being saved multiple times.
      if (loadedState.playbackSpeed == playbackSpeed) return;

      emit(loadedState.copyWith(playbackSpeed: playbackSpeed));
      _saveStateAsMergeSettings();
    }
  }

  void changeVideoResolution(VideoResolution videoResolution) {
    if (state case final SettingsBottomSheetLoaded loadedState) {
      final newState = switch (videoResolution) {
        VideoResolution.original => loadedState.copyWith(
            videoResolution: videoResolution,
            videoAspectRatio: VideoAspectRatio.firstVideo,
          ),
        _ => loadedState.copyWith(
            videoResolution: videoResolution,
            videoAspectRatio: VideoAspectRatio.auto,
          ),
      };
      emit(newState);
      _saveStateAsMergeSettings();
    }
  }

  void changeVideoAspectRatio(VideoAspectRatio videoAspectRatio) {
    if (state case final SettingsBottomSheetLoaded loadedState) {
      emit(loadedState.copyWith(videoAspectRatio: videoAspectRatio));
      _saveStateAsMergeSettings();
    }
  }
}
