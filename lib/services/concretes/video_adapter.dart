// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vmerge/src/features/edit/edit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

sealed class WechatAssetsPickerServiceException implements Exception {
  const WechatAssetsPickerServiceException(this.message, this.stackTrace);

  final String message;
  final String stackTrace;
}

final class GetVideoMetadataException
    extends WechatAssetsPickerServiceException {
  const GetVideoMetadataException(super.message, super.stackTrace);
}

final class WechatAssetsPickerService {
  const WechatAssetsPickerService();

  Future<List<VideoMetadata>> getVideoMetadatas(
    BuildContext context, {
    int maxAssets = 2,
    AssetPickerTextDelegate? textDelegate,
  }) async {
    final List<AssetEntity>? assets;
    final List<Uint8List?> thumbnails;
    final List<File?> files;
    try {
      assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 2,
          requestType: RequestType.video,
          pickerTheme: Theme.of(context),
          textDelegate: textDelegate ?? const EnglishAssetPickerTextDelegate(),
        ),
      );

      if (assets == null) throw Exception();

      thumbnails = await Future.wait(
        assets.map(
          (assetEntity) => assetEntity.thumbnailDataWithSize(
            const ThumbnailSize.square(256),
            format: ThumbnailFormat.png,
          ),
        ),
      );

      files = await Future.wait(
        assets.map((assetEntity) => assetEntity.loadFile()),
      );
    } catch (error, stackTrace) {
      throw GetVideoMetadataException(
        '[$WechatAssetsPickerService] - Could not get video metadata.',
        '$stackTrace',
      );
    }

    final videoMetadatas = <VideoMetadata>[];
    for (var i = 0; i < assets.length; i++) {
      videoMetadatas.add(
        VideoMetadata(
          title: assets[i].title,
          duration: assets[i].duration,
          thumbnail: thumbnails[i],
          file: files[i],
        ),
      );
    }

    return videoMetadatas;
  }
}
