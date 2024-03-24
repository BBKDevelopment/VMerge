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

final class MergePageCubit extends Cubit<MergePageState> {
  MergePageCubit(
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

  Future<void> loadVideoMetadata(List<VideoMetadata> metadataList) async {
    if (metadataList.length != 2) {
      emit(const MergePageError());
      return;
    }

    emit(const MergePageLoading());

    try {
      await Future.wait([
        _firstVideoPlayerService.loadFile(metadataList.first.file!),
        _secondVideoPlayerService.loadFile(metadataList.last.file!),
      ]);

      if (_firstVideoPlayerService.controller == null ||
          _secondVideoPlayerService.controller == null) {
        throw LoadVideoException();
      }

      emit(
        MergePageLoaded(
          metadatas: metadataList,
          activeVideoIndex: ActiveVideoIndex.one,
          videoPlayerController: _firstVideoPlayerService.controller!,
          videoHeight: _firstVideoPlayerService.height,
          videoWidth: _firstVideoPlayerService.width,
          isVideoPlaying: _firstVideoPlayerService.isPlaying,
          saveModalBottomSheetStatus: SaveModalBottomSheetStatus.idle,
        ),
      );
    } on LoadVideoException catch (error, stackTrace) {
      log(
        'Could not initialize video player!',
        name: '$MergePageCubit',
        error: error,
        stackTrace: stackTrace,
      );

      emit(const MergePageError());
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

          emit(const MergePageError());

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
          }

          emit(state.copyWith(isVideoPlaying: false));
        } on PauseVideoException catch (error, stackTrace) {
          log(
            'Could not stop video!',
            name: '$MergePageCubit',
            error: error,
            stackTrace: stackTrace,
          );

          emit(const MergePageError());

          // Restores last success state.
          emit(state);
        }
      default:
        return;
    }
  }

  Future<void> setVideoSpeedAndSound({
    required PlaybackSpeed speed,
    required bool isSoundOn,
  }) async {
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
          // TODO(BBarisKilic): Add this feature to package.
          // await Future.wait([
          //   _firstVideoPlayerService.setVolume(loadedState.isSoundOn ? 0 : 1),
          //   _secondVideoPlayerService.setVolume(loadedState.isSoundOn ? 0 : 1),
          // ]);

          await Future.wait([
            _firstVideoPlayerService.setPlaybackSpeed(speed.value),
            _secondVideoPlayerService.setPlaybackSpeed(speed.value),
            _firstVideoPlayerService.seekTo(Duration.zero),
            _secondVideoPlayerService.seekTo(Duration.zero),
          ]);
        } on SetVideoPlaybackSpeedException catch (error, stackTrace) {
          log(
            'Could not change the playback speed of the video!',
            name: '$MergePageCubit',
            error: error,
            stackTrace: stackTrace,
          );

          emit(const MergePageError());

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

  Future<void> mergeVideos() async {
    switch (state) {
      case final MergePageLoaded state:
        final appDocsDir = await getApplicationDocumentsDirectory();
        final outputVideoDir = path.join(appDocsDir.path, 'vmerge_output.mp4');
        final inputVideoDirs =
            state.metadatas.map((metadata) => metadata.file!.path).toList();

        await _ffmpegService.initThenAnalyseVideos(inputDirs: inputVideoDirs);
      // await _ffmpegService.mergeVideos(outputDir: outputVideoDir);
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