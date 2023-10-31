// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vmerge/controllers/controllers.dart';
import 'package:vmerge/models/models.dart';
import 'package:vmerge/services/abstracts/video_service.dart';
import 'package:vmerge/services/concretes/video_adapter.dart';

class HomePageController extends GetxController {
  late final BottomBarController _bottomBarController;
  late final VideoService _videoService;
  late List<Video> _videoList;

  List<Video> get getVideoList => _videoList;

  @override
  void onInit() {
    _bottomBarController = Get.find();
    _videoService = VideoAdapter();
    super.onInit();
  }

  Future<void> openAssetPicker(BuildContext context) async {
    _videoList = await _videoService.getAll(context);
    _bottomBarController.pageController.jumpToPage(1);
  }
}
