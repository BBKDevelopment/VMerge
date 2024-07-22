// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class MergePageCubit extends Cubit<MergePageState> {
  MergePageCubit()
      : _videoPlayerServices = LimitedList(maxLength: 2),
        super(const MergePageInitial());

  final LimitedList<VideoPlayerService> _videoPlayerServices;

  Future<void> loadVideoMetadata(
    List<VideoMetadata> metadatas, {
    required bool isSoundOn,
    required double playbackSpeed,
  }) async {
    if (metadatas.length < 2) {
      emit(
        const MergePageError(
          errorType: MergePageErrorType.insufficientVideoException,
        ),
      );
      return;
    }

    emit(const MergePageLoading());

    final volume = isSoundOn ? 1.0 : 0.0;

    try {
      for (var i = 0; i < _videoPlayerServices.maxLength; i++) {
        _videoPlayerServices.add(getIt<VideoPlayerService>());
      }
      // It is important to load the videos in parallel to avoid any delay.
      await Future.wait([
        // To reduce loading time, it is necessary to load only the first two
        // videos. If there are more than two videos, the rest will be loaded
        // when the first two videos are played.
        for (var i = 0; i < _videoPlayerServices.maxLength; i++)
          _videoPlayerServices[i].loadFile(
            metadatas[i].file!,
            volume: volume,
          ),
      ]);

      final isEveryVideoPlayerServiceReady =
          _videoPlayerServices.every((service) => service.isReady);
      if (!isEveryVideoPlayerServiceReady) throw const LoadVideoException();

      for (final videoPlayerService in _videoPlayerServices) {
        unawaited(videoPlayerService.setPlaybackSpeed(playbackSpeed));
      }

      _videoPlayerServices.first.addListener(_videoPlayerListener);

      emit(
        MergePageLoaded(
          videoMetadatas: metadatas,
          activeVideoIndex: 0,
          videoPlayerController: _videoPlayerServices.first.controller!,
          videoHeight: _videoPlayerServices.first.height,
          videoWidth: _videoPlayerServices.first.width,
          isVideoPlaying: _videoPlayerServices.first.isPlaying,
        ),
      );
    } on LoadVideoException catch (error, stackTrace) {
      log(
        'Could not initialize video player!',
        name: '$MergePageCubit',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        MergePageError(
          errorType: MergePageErrorType.loadVideoException,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<void> playVideo() async {
    switch (state) {
      case final MergePageLoaded state:
        try {
          await _videoPlayerServices.first.play();
          emit(state.copyWith(isVideoPlaying: true));
        } on PlayVideoException catch (error, stackTrace) {
          log(
            'Could not play video!',
            name: '$MergePageCubit',
            error: error,
            stackTrace: stackTrace,
          );
          emit(
            MergePageError(
              errorType: MergePageErrorType.playVideoException,
              error: error,
              stackTrace: stackTrace,
            ),
          );
          // Restores last success state.
          emit(state);
        }
      default:
        return;
    }
  }

  Future<void> stopVideo() async {
    switch (state) {
      case final MergePageLoaded state:
        try {
          await _videoPlayerServices.first.pause();
          emit(state.copyWith(isVideoPlaying: false));
        } on PauseVideoException catch (error, stackTrace) {
          log(
            'Could not stop video!',
            name: '$MergePageCubit',
            error: error,
            stackTrace: stackTrace,
          );
          emit(
            MergePageError(
              errorType: MergePageErrorType.pauseVideoException,
              error: error,
              stackTrace: stackTrace,
            ),
          );
          // Restores last success state.
          emit(state);
        }
      default:
        return;
    }
  }

  Future<void> setVideoSpeed(
    PlaybackSpeed speed,
  ) async {
    switch (state) {
      case final MergePageLoaded state:
        try {
          await Future.wait([
            for (final videoPlayerService in _videoPlayerServices)
              videoPlayerService.setPlaybackSpeed(speed.value),
          ]);
        } on SetVideoPlaybackSpeedException catch (error, stackTrace) {
          log(
            'Could not change the playback speed of the video!',
            name: '$MergePageCubit',
            error: error,
            stackTrace: stackTrace,
          );
          emit(
            MergePageError(
              errorType: MergePageErrorType.setVideoPlaybackSpeedException,
              error: error,
              stackTrace: stackTrace,
            ),
          );
          // Restores last success state.
          emit(state);
        }
      default:
        return;
    }
  }

  Future<void> setSound({
    required bool isSoundOn,
  }) async {
    switch (state) {
      case final MergePageLoaded state:
        final volume = isSoundOn ? 1.0 : 0.0;
        try {
          await Future.wait([
            for (final videoPlayerService in _videoPlayerServices)
              videoPlayerService.setVolume(volume),
          ]);
        } on SetVolumeException catch (error, stackTrace) {
          log(
            'Could not change the volume of the video!',
            name: '$MergePageCubit',
            error: error,
            stackTrace: stackTrace,
          );
          emit(
            MergePageError(
              errorType: MergePageErrorType.setVolumeException,
              error: error,
              stackTrace: stackTrace,
            ),
          );
          // Restores last success state.
          emit(state);
        }
      default:
        return;
    }
  }

  void _videoPlayerListener() {
    switch (state) {
      case final MergePageLoaded state:
        if (_videoPlayerServices.first.position !=
            _videoPlayerServices.first.duration) return;

        final oldVideoPlayerService =
            _videoPlayerServices.add(getIt<VideoPlayerService>());

        final activeVideoIndex =
            (state.activeVideoIndex + 1) % state.videoMetadatas.length;

        emit(
          state.copyWith(
            activeVideoIndex: activeVideoIndex,
            videoPlayerController: _videoPlayerServices.first.controller,
            videoWidth: _videoPlayerServices.first.width,
            videoHeight: _videoPlayerServices.first.height,
            isVideoPlaying: activeVideoIndex != 0,
          ),
        );

        // Add the listener to the current video player service.
        _videoPlayerServices.first.addListener(_videoPlayerListener);

        // Dispose the old video player service.
        oldVideoPlayerService?.removeListener(_videoPlayerListener);
        oldVideoPlayerService?.dispose();

        // Load the next video.
        final nextVideoIndex =
            (activeVideoIndex + 1) % state.videoMetadatas.length;
        _videoPlayerServices.last.loadFile(
          state.videoMetadatas[nextVideoIndex].file!,
          // TODO(all): Add volume getter to the VideoPlayerService.
          volume: state.videoPlayerController.value.volume,
        );
        _videoPlayerServices.last
            .setPlaybackSpeed(_videoPlayerServices.first.playbackSpeed);

        // Play the current video.
        if (activeVideoIndex != 0) playVideo();
      default:
        return;
    }
  }

  @override
  Future<void> close() {
    for (final videoPlayerService in _videoPlayerServices) {
      videoPlayerService
        ..removeListener(_videoPlayerListener)
        ..dispose();
    }
    return super.close();
  }
}
