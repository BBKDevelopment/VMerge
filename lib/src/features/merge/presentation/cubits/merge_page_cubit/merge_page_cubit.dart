// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class MergePageCubit extends Cubit<MergePageState> {
  MergePageCubit({
    required VideoPlayerService firstVideoPlayerService,
    required VideoPlayerService secondVideoPlayerService,
    required VideoPlayerService thirdVideoPlayerService,
    required VideoPlayerService fourthVideoPlayerService,
  })  : _firstVideoPlayerService = firstVideoPlayerService,
        _secondVideoPlayerService = secondVideoPlayerService,
        _thirdVideoPlayerService = thirdVideoPlayerService,
        _fourthVideoPlayerService = fourthVideoPlayerService,
        super(const MergePageInitial());

  final VideoPlayerService _firstVideoPlayerService;
  final VideoPlayerService _secondVideoPlayerService;
  final VideoPlayerService _thirdVideoPlayerService;
  final VideoPlayerService _fourthVideoPlayerService;

  VoidCallback get _firstVideoPlayerListener => () {
        switch (state) {
          case final MergePageLoaded state:
            if (_firstVideoPlayerService.position.inSeconds !=
                _firstVideoPlayerService.duration.inSeconds) return;

            _firstVideoPlayerService
              ..seekTo(Duration.zero)
              ..pause();

            emit(
              state.copyWith(
                activeVideoIndex: ActiveVideoIndex.two,
                videoPlayerController: _secondVideoPlayerService.controller,
                videoWidth: _secondVideoPlayerService.width,
                videoHeight: _secondVideoPlayerService.height,
                isVideoPlaying: true,
              ),
            );

            _secondVideoPlayerService.play();
          default:
            return;
        }
      };

  VoidCallback get _secondVideoPlayerListener => () {
        switch (state) {
          case final MergePageLoaded state:
            if (_secondVideoPlayerService.position.inSeconds !=
                _secondVideoPlayerService.duration.inSeconds) return;

            _secondVideoPlayerService
              ..seekTo(Duration.zero)
              ..pause();

            emit(
              state.copyWith(
                activeVideoIndex: _thirdVideoPlayerService.isReady
                    ? ActiveVideoIndex.three
                    : ActiveVideoIndex.one,
                videoPlayerController: _thirdVideoPlayerService.isReady
                    ? _thirdVideoPlayerService.controller
                    : _firstVideoPlayerService.controller,
                videoHeight: _thirdVideoPlayerService.isReady
                    ? _thirdVideoPlayerService.height
                    : _firstVideoPlayerService.height,
                videoWidth: _thirdVideoPlayerService.isReady
                    ? _thirdVideoPlayerService.width
                    : _firstVideoPlayerService.width,
                isVideoPlaying: _thirdVideoPlayerService.isReady,
              ),
            );

            if (_thirdVideoPlayerService.isReady) {
              _thirdVideoPlayerService.play();
            }
          default:
            return;
        }
      };

  VoidCallback get _thirdVideoPlayerListener => () {
        switch (state) {
          case final MergePageLoaded state:
            if (_thirdVideoPlayerService.position.inSeconds !=
                _thirdVideoPlayerService.duration.inSeconds) return;

            _thirdVideoPlayerService
              ..seekTo(Duration.zero)
              ..pause();

            emit(
              state.copyWith(
                activeVideoIndex: _fourthVideoPlayerService.isReady
                    ? ActiveVideoIndex.four
                    : ActiveVideoIndex.one,
                videoPlayerController: _fourthVideoPlayerService.isReady
                    ? _fourthVideoPlayerService.controller
                    : _firstVideoPlayerService.controller,
                videoHeight: _fourthVideoPlayerService.isReady
                    ? _fourthVideoPlayerService.height
                    : _firstVideoPlayerService.height,
                videoWidth: _fourthVideoPlayerService.isReady
                    ? _fourthVideoPlayerService.width
                    : _firstVideoPlayerService.width,
                isVideoPlaying: _fourthVideoPlayerService.isReady,
              ),
            );

            if (_fourthVideoPlayerService.isReady) {
              _fourthVideoPlayerService.play();
            }
          default:
            return;
        }
      };

  VoidCallback get _fourthVideoPlayerListener => () {
        switch (state) {
          case final MergePageLoaded state:
            if (_fourthVideoPlayerService.position.inSeconds !=
                _fourthVideoPlayerService.duration.inSeconds) return;

            _fourthVideoPlayerService
              ..seekTo(Duration.zero)
              ..pause();

            emit(
              state.copyWith(
                activeVideoIndex: ActiveVideoIndex.one,
                videoPlayerController: _firstVideoPlayerService.controller,
                videoHeight: _firstVideoPlayerService.height,
                videoWidth: _firstVideoPlayerService.width,
                isVideoPlaying: false,
              ),
            );
          default:
            return;
        }
      };

  Future<void> loadVideoMetadata(
    List<VideoMetadata> metadatas, {
    required bool isSoundOn,
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
      await Future.wait([
        _firstVideoPlayerService.loadFile(
          metadatas[0].file!,
          volume: volume,
        ),
        _secondVideoPlayerService.loadFile(
          metadatas[1].file!,
          volume: volume,
        ),
        if (metadatas.length > 2)
          _thirdVideoPlayerService.loadFile(
            metadatas[2].file!,
            volume: volume,
          ),
        if (metadatas.length > 3)
          _fourthVideoPlayerService.loadFile(
            metadatas[3].file!,
            volume: volume,
          ),
      ]);

      if (metadatas.length > 1 && _firstVideoPlayerService.controller == null ||
          _secondVideoPlayerService.controller == null) {
        throw const LoadVideoException();
      }
      if (metadatas.length > 2 && _thirdVideoPlayerService.controller == null) {
        throw const LoadVideoException();
      }
      if (metadatas.length > 3 &&
          _fourthVideoPlayerService.controller == null) {
        throw const LoadVideoException();
      }

      emit(
        MergePageLoaded(
          videoMetadatas: metadatas,
          activeVideoIndex: ActiveVideoIndex.one,
          videoPlayerController: _firstVideoPlayerService.controller!,
          videoHeight: _firstVideoPlayerService.height,
          videoWidth: _firstVideoPlayerService.width,
          isVideoPlaying: _firstVideoPlayerService.isPlaying,
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
        _addVideoPlayerListeners();

        try {
          switch (state.activeVideoIndex) {
            case ActiveVideoIndex.one:
              await _firstVideoPlayerService.play();
            case ActiveVideoIndex.two:
              await _secondVideoPlayerService.play();
            case ActiveVideoIndex.three:
              await _thirdVideoPlayerService.play();
            case ActiveVideoIndex.four:
              await _fourthVideoPlayerService.play();
          }

          emit(state.copyWith(isVideoPlaying: true));
        } on PlayVideoException catch (error, stackTrace) {
          log(
            'Could not play video!',
            name: '$MergePageCubit',
            error: error,
            stackTrace: stackTrace,
          );

          _removeVideoPlayerListeners();

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
        _removeVideoPlayerListeners();

        try {
          switch (state.activeVideoIndex) {
            case ActiveVideoIndex.one:
              await _firstVideoPlayerService.pause();
            case ActiveVideoIndex.two:
              await _secondVideoPlayerService.pause();
            case ActiveVideoIndex.three:
              await _thirdVideoPlayerService.pause();
            case ActiveVideoIndex.four:
              await _fourthVideoPlayerService.pause();
          }
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
        emit(
          state.copyWith(
            activeVideoIndex: ActiveVideoIndex.one,
            videoPlayerController: _firstVideoPlayerService.controller,
            videoHeight: _firstVideoPlayerService.height,
            videoWidth: _firstVideoPlayerService.width,
          ),
        );

        try {
          await Future.wait([
            _firstVideoPlayerService.setPlaybackSpeed(speed.value),
            _secondVideoPlayerService.setPlaybackSpeed(speed.value),
            _thirdVideoPlayerService.setPlaybackSpeed(speed.value),
            _fourthVideoPlayerService.setPlaybackSpeed(speed.value),
            _firstVideoPlayerService.seekTo(Duration.zero),
            _secondVideoPlayerService.seekTo(Duration.zero),
            _thirdVideoPlayerService.seekTo(Duration.zero),
            _fourthVideoPlayerService.seekTo(Duration.zero),
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
        } on SeekVideoPositionException catch (error, stackTrace) {
          log(
            'Could not reset the video!',
            name: '$MergePageCubit',
            error: error,
            stackTrace: stackTrace,
          );
          emit(
            MergePageError(
              errorType: MergePageErrorType.seekVideoPositionException,
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
            _firstVideoPlayerService.setVolume(volume),
            _secondVideoPlayerService.setVolume(volume),
            _thirdVideoPlayerService.setVolume(volume),
            _fourthVideoPlayerService.setVolume(volume),
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

  void _addVideoPlayerListeners() {
    _firstVideoPlayerService.addListener(_firstVideoPlayerListener);
    _secondVideoPlayerService.addListener(_secondVideoPlayerListener);
    _thirdVideoPlayerService.addListener(_thirdVideoPlayerListener);
    _fourthVideoPlayerService.addListener(_fourthVideoPlayerListener);
  }

  void _removeVideoPlayerListeners() {
    _firstVideoPlayerService.removeListener(_firstVideoPlayerListener);
    _secondVideoPlayerService.removeListener(_secondVideoPlayerListener);
    _thirdVideoPlayerService.removeListener(_thirdVideoPlayerListener);
    _fourthVideoPlayerService.removeListener(_fourthVideoPlayerListener);
  }

  @override
  Future<void> close() {
    _removeVideoPlayerListeners();
    _firstVideoPlayerService.dispose();
    _secondVideoPlayerService.dispose();
    _thirdVideoPlayerService.dispose();
    _fourthVideoPlayerService.dispose();
    return super.close();
  }
}
