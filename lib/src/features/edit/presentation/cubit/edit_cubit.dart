// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/src/features/edit/edit.dart';

final class EditCubit extends Cubit<EditState> {
  EditCubit(
    super.initialState, {
    required VideoPlayerService firstVideoPlayerService,
    required VideoPlayerService secondVideoPlayerService,
  })  : _firstVideoPlayerService = firstVideoPlayerService,
        _secondVideoPlayerService = secondVideoPlayerService;

  final VideoPlayerService _firstVideoPlayerService;
  final VideoPlayerService _secondVideoPlayerService;

  VoidCallback get _firstVideoPlayerListener => () {
        if (state is! EditLoaded) return;
        if (_firstVideoPlayerService.position.inSeconds !=
            _firstVideoPlayerService.duration.inSeconds) return;

        _firstVideoPlayerService
          ..seekTo(Duration.zero)
          ..pause();

        emit(
          (state as EditLoaded).copyWith(
            activeVideoIndex: ActiveVideoIndex.two,
            videoPlayerController: _secondVideoPlayerService.controller,
            videoHeight: _secondVideoPlayerService.height,
            videoWidth: _secondVideoPlayerService.width,
            isVideoPlaying: true,
          ),
        );

        _secondVideoPlayerService.play();
      };

  VoidCallback get _secondVideoPlayerListener => () {
        if (state is! EditLoaded) return;
        if (_secondVideoPlayerService.position.inSeconds !=
            _secondVideoPlayerService.duration.inSeconds) return;

        _secondVideoPlayerService
          ..seekTo(Duration.zero)
          ..pause();

        emit(
          (state as EditLoaded).copyWith(
            activeVideoIndex: ActiveVideoIndex.one,
            videoPlayerController: _firstVideoPlayerService.controller,
            videoHeight: _firstVideoPlayerService.height,
            videoWidth: _firstVideoPlayerService.width,
            isVideoPlaying: false,
          ),
        );
      };

  Future<void> loadVideoMetadatas(List<VideoMetadata> metadatas) async {
    if (metadatas.length != 2) {
      emit(const EditError());
      return;
    }

    emit(const EditLoading());

    try {
      await Future.wait([
        _firstVideoPlayerService.loadFile(metadatas.first.file!),
        _secondVideoPlayerService.loadFile(metadatas.last.file!),
      ]);

      if (_firstVideoPlayerService.controller == null ||
          _secondVideoPlayerService.controller == null) {
        throw LoadVideoException();
      }

      emit(
        EditLoaded(
          metadatas: metadatas,
          activeVideoIndex: ActiveVideoIndex.one,
          videoPlayerController: _firstVideoPlayerService.controller!,
          videoHeight: _firstVideoPlayerService.height,
          videoWidth: _firstVideoPlayerService.width,
          isVideoPlaying: _firstVideoPlayerService.isPlaying,
          playbackSpeed: PlaybackSpeed.one,
          videoQuality: VideoQuality.original,
          saveModalBottomSheetStatus: SaveModalBottomSheetStatus.idle,
        ),
      );
    } on LoadVideoException catch (error, stackTrace) {
      log(
        'Could not initialize video player!',
        name: '$EditCubit',
        error: error,
        stackTrace: stackTrace,
      );

      emit(const EditError());
    }
  }

  Future<void> playVideo() async {
    if (state is! EditLoaded) return;

    final loadedState = state as EditLoaded;

    _addVideoPlayerListeners();

    try {
      switch (loadedState.activeVideoIndex) {
        case ActiveVideoIndex.one:
          await _firstVideoPlayerService.play();
        case ActiveVideoIndex.two:
          await _secondVideoPlayerService.play();
      }

      emit(loadedState.copyWith(isVideoPlaying: true));
    } on PlayVideoException catch (error, stackTrace) {
      log(
        'Could not play video!',
        name: '$EditCubit',
        error: error,
        stackTrace: stackTrace,
      );

      _removeVideoPlayerListeners();

      emit(const EditError());

      // Restores last success state.
      emit(loadedState);
    }
  }

  Future<void> stopVideo() async {
    if (state is! EditLoaded) return;

    final loadedState = state as EditLoaded;

    _removeVideoPlayerListeners();

    try {
      switch (loadedState.activeVideoIndex) {
        case ActiveVideoIndex.one:
          await _firstVideoPlayerService.pause();
        case ActiveVideoIndex.two:
          await _secondVideoPlayerService.pause();
      }

      emit(loadedState.copyWith(isVideoPlaying: false));
    } on PauseVideoException catch (error, stackTrace) {
      log(
        'Could not stop video!',
        name: '$EditCubit',
        error: error,
        stackTrace: stackTrace,
      );

      emit(const EditError());

      // Restores last success state.
      emit(loadedState);
    }
  }

  Future<void> setPlaybackSpeed(PlaybackSpeed speed) async {
    if (state is! EditLoaded) return;

    final loadedState = state as EditLoaded;

    try {
      await Future.wait([
        _firstVideoPlayerService.setPlaybackSpeed(speed.value),
        _secondVideoPlayerService.setPlaybackSpeed(speed.value),
        _firstVideoPlayerService.seekTo(Duration.zero),
        _secondVideoPlayerService.seekTo(Duration.zero),
      ]);

      emit(
        loadedState.copyWith(
          activeVideoIndex: ActiveVideoIndex.one,
          videoPlayerController: _firstVideoPlayerService.controller,
          videoHeight: _firstVideoPlayerService.height,
          videoWidth: _firstVideoPlayerService.width,
        ),
      );
    } on SetVideoPlaybackSpeedException catch (error, stackTrace) {
      log(
        'Could not change the playback speed of the video!',
        name: '$EditCubit',
        error: error,
        stackTrace: stackTrace,
      );

      emit(const EditError());

      // Restores last success state.
      emit(loadedState);
    } on SeekVideoPositionException catch (error, stackTrace) {
      log(
        'Could not reset the video!',
        name: '$EditCubit',
        error: error,
        stackTrace: stackTrace,
      );

      emit(
        loadedState.copyWith(
          activeVideoIndex: ActiveVideoIndex.one,
          videoPlayerController: _firstVideoPlayerService.controller,
          videoHeight: _firstVideoPlayerService.height,
          videoWidth: _firstVideoPlayerService.width,
        ),
      );
    }
  }

  Future<void> setVideoQuality(VideoQuality quality) async {
    if (state is! EditLoaded) return;

    (state as EditLoaded).copyWith(videoQuality: quality);
  }

  void _addVideoPlayerListeners() {
    _firstVideoPlayerService.addListener(_firstVideoPlayerListener);
    _secondVideoPlayerService.addListener(_secondVideoPlayerListener);
  }

  void _removeVideoPlayerListeners() {
    _firstVideoPlayerService.removeListener(_firstVideoPlayerListener);
    _secondVideoPlayerService.removeListener(_secondVideoPlayerListener);
  }
}
