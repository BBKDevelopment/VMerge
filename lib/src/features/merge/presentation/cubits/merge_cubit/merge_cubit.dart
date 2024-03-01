// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:vmerge/src/features/merge/presentation/cubits/ffmpeg_service.dart';

final class MergeCubit extends Cubit<MergeState> {
  MergeCubit(
    super.initialState, {
    required VideoPlayerService firstVideoPlayerService,
    required VideoPlayerService secondVideoPlayerService,
  })  : _firstVideoPlayerService = firstVideoPlayerService,
        _secondVideoPlayerService = secondVideoPlayerService;

  final VideoPlayerService _firstVideoPlayerService;
  final VideoPlayerService _secondVideoPlayerService;
  final FFmpegService _ffmpegService = FFmpegService();

  VoidCallback get _firstVideoPlayerListener => () {
        switch (state) {
          case final MergeLoaded state:
            if (_firstVideoPlayerService.position.inSeconds !=
                _firstVideoPlayerService.duration.inSeconds) return;

            _firstVideoPlayerService
              ..seekTo(Duration.zero)
              ..pause();

            emit(
              state.copyWith(
                activeVideoIndex: ActiveVideoIndex.two,
                videoPlayerController: _secondVideoPlayerService.controller,
                videoWidth:
                    state.videoAspectRatio == VideoAspectRatio.firstVideo
                        ? _firstVideoPlayerService.width
                        : _secondVideoPlayerService.width,
                videoHeight:
                    state.videoAspectRatio == VideoAspectRatio.firstVideo
                        ? _firstVideoPlayerService.height
                        : _secondVideoPlayerService.height,
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
          case final MergeLoaded state:
            if (_secondVideoPlayerService.position.inSeconds !=
                _secondVideoPlayerService.duration.inSeconds) return;

            _secondVideoPlayerService
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
          isSoundOn: true,
          playbackSpeed: PlaybackSpeed.one,
          videoResolution: VideoResolution.original,
          videoAspectRatio: VideoAspectRatio.independent,
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
    switch (state) {
      case final MergeLoaded state:
        _addVideoPlayerListeners();

        try {
          switch (state.activeVideoIndex) {
            case ActiveVideoIndex.one:
              await _firstVideoPlayerService.play();
            case ActiveVideoIndex.two:
              await _secondVideoPlayerService.play();
          }

          emit(state.copyWith(isVideoPlaying: true));
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
          emit(state);
        }
      default:
        return;
    }
  }

  Future<void> stopVideo() async {
    switch (state) {
      case final MergeLoaded state:
        _removeVideoPlayerListeners();

        try {
          switch (state.activeVideoIndex) {
            case ActiveVideoIndex.one:
              await _firstVideoPlayerService.pause();
            case ActiveVideoIndex.two:
              await _secondVideoPlayerService.pause();
          }

          emit(state.copyWith(isVideoPlaying: false));
        } on PauseVideoException catch (error, stackTrace) {
          log(
            'Could not stop video!',
            name: '$MergeCubit',
            error: error,
            stackTrace: stackTrace,
          );

          emit(const MergeError());

          // Restores last success state.
          emit(state);
        }
      default:
        return;
    }
  }

  Future<void> changePlaybackSpeed(PlaybackSpeed speed) async {
    switch (state) {
      case final MergeLoaded state:
        if (state.playbackSpeed == speed) return;

        emit(
          state.copyWith(
            activeVideoIndex: ActiveVideoIndex.one,
            playbackSpeed: speed,
            videoPlayerController: _firstVideoPlayerService.controller,
            videoHeight: _firstVideoPlayerService.height,
            videoWidth: _firstVideoPlayerService.width,
          ),
        );

        try {
          await Future.wait([
            _firstVideoPlayerService.setPlaybackSpeed(speed.value),
            _secondVideoPlayerService.setPlaybackSpeed(speed.value),
            _firstVideoPlayerService.seekTo(Duration.zero),
            _secondVideoPlayerService.seekTo(Duration.zero),
          ]);
        } on SetVideoPlaybackSpeedException catch (error, stackTrace) {
          log(
            'Could not change the playback speed of the video!',
            name: '$MergeCubit',
            error: error,
            stackTrace: stackTrace,
          );

          emit(const MergeError());

          // Restores last success state.
          emit(state);
        } on SeekVideoPositionException catch (error, stackTrace) {
          log(
            'Could not reset the video!',
            name: '$MergeCubit',
            error: error,
            stackTrace: stackTrace,
          );

          emit(
            state.copyWith(
              activeVideoIndex: ActiveVideoIndex.one,
              videoPlayerController: _firstVideoPlayerService.controller,
              videoHeight: _firstVideoPlayerService.height,
              videoWidth: _firstVideoPlayerService.width,
            ),
          );

          // Restores last success state.
          emit(state);
        }
      default:
        return;
    }
  }

  Future<void> toggleSound({required bool isSoundOn}) async {
    switch (state) {
      case final MergeLoaded state:
        // TODO(BBarisKilic): Add this feature to package.
        // await Future.wait([
        //   _firstVideoPlayerService.setVolume(loadedState.isSoundOn ? 0 : 1),
        //   _secondVideoPlayerService.setVolume(loadedState.isSoundOn ? 0 : 1),
        // ]);

        emit(state.copyWith(isSoundOn: isSoundOn));
      default:
        return;
    }
  }

  void changeVideoResolution(VideoResolution resolution) {
    switch (state) {
      case final MergeLoaded state:
        emit(
          state.copyWith(
            videoResolution: resolution,
            videoAspectRatio: resolution.aspectRatio != null
                ? VideoAspectRatio.auto
                : VideoAspectRatio.independent,
          ),
        );
      default:
        return;
    }
  }

  void changeVideoAspectRatio(VideoAspectRatio ratio) {
    switch (state) {
      case final MergeLoaded state:
        emit(state.copyWith(videoAspectRatio: ratio));
      default:
        return;
    }
  }

  Future<void> setVideoQuality(VideoResolution quality) async {
    switch (state) {
      case final MergeLoaded state:
        state.copyWith(videoResolution: quality);
      default:
        return;
    }
  }

  Future<void> mergeVideos() async {
    switch (state) {
      case final MergeLoaded state:
        final appDocumentsDir = await getApplicationDocumentsDirectory();
        final outputVideoDir =
            path.join(appDocumentsDir.path, 'vmerge_output.mp4');
        final inputVideoDirs =
            state.metadatas.map((metadata) => metadata.file!.path).toList();

        await _ffmpegService.initThenAnalyseVideos(inputDirs: inputVideoDirs);
        await _ffmpegService.mergeVideos(outputDir: outputVideoDir);
      default:
        return;
    }
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
