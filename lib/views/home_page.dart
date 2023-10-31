// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/controllers/home_page_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key}) {
    _homePageController = Get.find();
  }

  late final HomePageController _homePageController;

  @override
  Widget build(BuildContext context) {
    _homePageController.openAssetPicker(context);

    return const Scaffold(
      appBar: VMergeAppBar(),
    );
  }
}
