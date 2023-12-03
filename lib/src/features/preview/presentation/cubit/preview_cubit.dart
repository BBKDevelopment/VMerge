// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:vmerge/src/features/edit/edit.dart';
import 'package:vmerge/src/features/preview/preview.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

final class PreviewCubit extends Cubit<PreviewState> {
  PreviewCubit(super.initialState);

  void resetVideos() {
    emit(const PreviewLoading());
  }

  Future<void> updateVideos(List<AssetEntity>? assets) async {
    final videos = <VideoMetadata>[];

    try {
      for (final asset in assets ?? <AssetEntity>[]) {
        final loadedAsset = await _loadAsset(asset);
        videos.add(
          VideoMetadata(
            title: asset.title,
            duration: asset.duration,
            thumbnail: loadedAsset.image,
            file: loadedAsset.file,
          ),
        );
      }
      emit(PreviewLoaded(metadatas: videos));
    } catch (_) {
      emit(const PreviewError());
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
