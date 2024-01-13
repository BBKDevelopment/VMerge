// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class MergeCubit extends Cubit<MergeState> {
  MergeCubit(
    super.initialState, {
    required VideoPlayerService firstVideoPlayerService,
    required VideoPlayerService secondVideoPlayerService,
  })  : _firstVideoPlayerService = firstVideoPlayerService,
        _secondVideoPlayerService = secondVideoPlayerService;

  final VideoPlayerService _firstVideoPlayerService;
  final VideoPlayerService _secondVideoPlayerService;

  VoidCallback get _firstVideoPlayerListener => () {
        if (state is! MergeLoaded) return;
        if (_firstVideoPlayerService.position.inSeconds !=
            _firstVideoPlayerService.duration.inSeconds) return;

        _firstVideoPlayerService
          ..seekTo(Duration.zero)
          ..pause();

        emit(
          (state as MergeLoaded).copyWith(
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
        if (state is! MergeLoaded) return;
        if (_secondVideoPlayerService.position.inSeconds !=
            _secondVideoPlayerService.duration.inSeconds) return;

        _secondVideoPlayerService
          ..seekTo(Duration.zero)
          ..pause();

        emit(
          (state as MergeLoaded).copyWith(
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
      emit(const MergeError());
      return;
    }

    emit(const MergeLoading());

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
        MergeLoaded(
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
        name: '$MergeCubit',
        error: error,
        stackTrace: stackTrace,
      );

      emit(const MergeError());
    }
  }

  Future<void> playVideo() async {
    if (state is! MergeLoaded) return;

    final loadedState = state as MergeLoaded;

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
        name: '$MergeCubit',
        error: error,
        stackTrace: stackTrace,
      );

      _removeVideoPlayerListeners();

      emit(const MergeError());

      // Restores last success state.
      emit(loadedState);
    }
  }

  Future<void> stopVideo() async {
    if (state is! MergeLoaded) return;

    final loadedState = state as MergeLoaded;

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
        name: '$MergeCubit',
        error: error,
        stackTrace: stackTrace,
      );

      emit(const MergeError());

      // Restores last success state.
      emit(loadedState);
    }
  }

  Future<void> setPlaybackSpeed(PlaybackSpeed speed) async {
    if (state is! MergeLoaded) return;

    final loadedState = state as MergeLoaded;

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
        name: '$MergeCubit',
        error: error,
        stackTrace: stackTrace,
      );

      emit(const MergeError());

      // Restores last success state.
      emit(loadedState);
    } on SeekVideoPositionException catch (error, stackTrace) {
      log(
        'Could not reset the video!',
        name: '$MergeCubit',
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
    if (state is! MergeLoaded) return;

    (state as MergeLoaded).copyWith(videoQuality: quality);
  }

  void _addVideoPlayerListeners() {
    _firstVideoPlayerService.addListener(_firstVideoPlayerListener);
    _secondVideoPlayerService.addListener(_secondVideoPlayerListener);
  }

  void _removeVideoPlayerListeners() {
    _firstVideoPlayerService.removeListener(_firstVideoPlayerListener);
    _secondVideoPlayerService.removeListener(_secondVideoPlayerListener);
  }

  @override
  Future<void> close() {
    _removeVideoPlayerListeners();
    _firstVideoPlayerService.dispose();
    _secondVideoPlayerService.dispose();
    return super.close();
  }
}
