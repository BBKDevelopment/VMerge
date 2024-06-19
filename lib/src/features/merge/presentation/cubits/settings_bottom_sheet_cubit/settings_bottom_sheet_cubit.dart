// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

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
        super(const SettingsBottomSheetInitial());

  final GetMergeSettingsUseCase _getMergeSettingsUseCase;
  final SaveMergeSettingsUseCase _saveMergeSettingsUseCase;

  Future<void> init() async {
    final settings = await _getMergeSettings();

    emit(
      SettingsBottomSheetLoaded(
        isAudioOn: settings?.isAudioOn ?? true,
        playbackSpeed: settings?.playbackSpeed ?? PlaybackSpeed.one,
        videoResolution: settings?.videoResolution ?? VideoResolution.original,
        videoAspectRatio:
            settings?.videoAspectRatio ?? VideoAspectRatio.firstVideo,
      ),
    );
  }

  Future<MergeSettings?> _getMergeSettings() async {
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
        return null;
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
        isAudioOn: loadedState.isAudioOn,
        playbackSpeed: loadedState.playbackSpeed,
        videoResolution: loadedState.videoResolution,
        videoAspectRatio: loadedState.videoAspectRatio,
      );
      _saveMergeSettings(settings);
    }
  }

  void toggleSound({required bool isAudioOn}) {
    if (state case final SettingsBottomSheetLoaded loadedState) {
      emit(loadedState.copyWith(isAudioOn: isAudioOn));
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
