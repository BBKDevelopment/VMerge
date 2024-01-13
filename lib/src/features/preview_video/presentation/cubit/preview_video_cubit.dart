// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:vmerge/src/features/preview_video/preview_video.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

final class PreviewVideoCubit extends Cubit<PreviewVideoState> {
  PreviewVideoCubit(super.initialState);

  void resetVideos() {
    emit(const PreviewVideoLoading());
  }

  Future<void> updateVideos(List<AssetEntity>? assets) async {
    final videoMetadatas = <VideoMetadata>[];

    try {
      assert(assets!.length >= 2, 'At least 2 videos are required');

      for (final asset in assets!) {
        final loadedAsset = await _loadAsset(asset);
        videoMetadatas.add(
          VideoMetadata(
            title: asset.title,
            duration: asset.duration,
            thumbnail: loadedAsset.image,
            file: loadedAsset.file,
          ),
        );
      }

      emit(PreviewVideoLoaded(metadatas: videoMetadatas));
    } catch (_) {
      emit(const PreviewVideoError());
    }
  }

  Future<({Uint8List image, File file})> _loadAsset(AssetEntity asset) async {
    final loadedAsset = await Future.wait([
      asset.thumbnailDataWithSize(
        const ThumbnailSize.square(256),
        format: ThumbnailFormat.png,
      ),
      asset.loadFile(),
    ]);

    return (image: loadedAsset[0]! as Uint8List, file: loadedAsset[1]! as File);
  }
}
