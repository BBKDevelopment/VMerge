// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:vmerge/src/features/video_select/video_select.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

final class VideoSelectPageCubit extends Cubit<VideoSelectPageState> {
  VideoSelectPageCubit(super.initialState);

  void resetVideos() {
    emit(const VideoSelectPageLoading());
  }

  Future<void> updateVideos(List<AssetEntity>? assets) async {
    if (assets!.length < 2) {
      emit(
        const VideoSelectPageError(
          errorType: VideoSelectPageErrorType.insufficientVideoException,
        ),
      );
    }

    final videoMetadataList = <VideoMetadata>[];
    try {
      for (final asset in assets) {
        final loadedAsset = await _loadAsset(asset);
        videoMetadataList.add(
          VideoMetadata(
            title: asset.title,
            duration: asset.duration,
            thumbnail: loadedAsset.image,
            file: loadedAsset.file,
          ),
        );
      }

      emit(VideoSelectPageLoaded(metadataList: videoMetadataList));
    } catch (error, stackTrace) {
      emit(
        VideoSelectPageError(
          errorType: VideoSelectPageErrorType.loadingVideoException,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<({Uint8List? image, File? file})> _loadAsset(AssetEntity asset) async {
    final loadedAsset = await Future.wait([
      asset.thumbnailDataWithSize(
        const ThumbnailSize.square(256),
      ),
      asset.loadFile(),
    ]);

    return (image: loadedAsset[0] as Uint8List?, file: loadedAsset[1] as File?);
  }
}
