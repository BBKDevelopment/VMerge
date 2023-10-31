// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vmerge/controllers/controllers.dart';
import 'package:vmerge/models/models.dart';
import 'package:vmerge/services/abstracts/video_service.dart';
import 'package:vmerge/utilities/utilities.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class VideoAdapter extends VideoService {
  VideoAdapter() {
    _videoList = <Video>[];
    _editPageController = Get.find();
  }
  late final List<Video> _videoList;
  late final EditPageController _editPageController;

  @override
  Future<List<Video>> getAll(BuildContext context) async {
    final pickerConfig = AssetPickerConfig(
      maxAssets: 2,
      requestType: RequestType.video,
      pickerTheme: appTheme,
      textDelegate: const EnglishAssetPickerTextDelegate(),
    );

    final assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: pickerConfig,
    );

    //clear old list
    _videoList.clear();

    for (var i = 0; i < (assets?.length ?? 0); i++) {
      if (assets == null) break;
      _videoList.add(
        Video(
          title: assets[i].title,
          duration: assets[i].duration,
          image: await assets[i].thumbnailDataWithSize(
            const ThumbnailSize.square(256),
            format: ThumbnailFormat.png,
          ),
          file: await assets[i].loadFile(),
        ),
      );
    }

    if (_videoList.length > 1) {
      await _editPageController.setFile(_videoList[0].file, _videoList[1].file);
    } else {
      _editPageController.file.clear();
      _editPageController.assets.clear();
    }

    return _videoList;
  }
}
