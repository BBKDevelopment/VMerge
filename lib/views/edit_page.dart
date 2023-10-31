// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/controllers/controllers.dart';
import 'package:vmerge/utilities/utilities.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final EditPageController _editPageController;

  @override
  void initState() {
    super.initState();
    _editPageController = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _editPageController.initVideoPlayer();
    });
  }

  @override
  void dispose() {
    _editPageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VMergeAppBar(),
      body: Container(
        color: kPrimaryColorDark,
        child: Column(
          children: [
            Flexible(
              child: AnimatedBuilder(
                animation: _editPageController.getAnimation,
                builder: (BuildContext context, Widget? child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _editPageController.getAnimation,
                      curve: const Interval(
                        0.70,
                        1,
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                    child: child,
                  );
                },
                child: Obx(() {
                  return _editPageController.isVideoReady.value
                      ? _buildVideoPlayer(
                          _editPageController.currentVideo == 1
                              ? _editPageController.videoPlayerController
                              : _editPageController.videoPlayerControllerTwo,
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Center(
                            child: Text(
                              kSelectVideoText,
                              style: kSemiBoldTextStyle,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22, bottom: 10),
              child: _buildControlPanel(context),
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildVideoPlayer(VideoPlayerController videoPlayerController) {
    return Stack(
      children: [
        Positioned.fill(
          child: FittedBox(
            child: (videoPlayerController.value.aspectRatio < 1)
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(kVerticalVideoBorderRadius),
                      child: SizedBox(
                        height: videoPlayerController.value.size.height,
                        width: videoPlayerController.value.size.width,
                        child: VideoPlayer(videoPlayerController),
                      ),
                    ),
                  )
                : SizedBox(
                    height: videoPlayerController.value.size.height,
                    width: videoPlayerController.value.size.width,
                    child: VideoPlayer(videoPlayerController),
                  ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              _editPageController.onTappedPlayButton();
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Obx(
                () => _editPageController.isVideoPlaying
                    ? const SizedBox()
                    : Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kPrimaryColorDark.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Positioned(
                            //center is left:15
                            left: 17,
                            child: SvgPicture.asset(
                              kPlayIconPath,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildControlPanel(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          color: kPrimaryColor,
          thickness: 1,
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _editPageController.onTappedSettingsButton,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                child: AnimatedBuilder(
                  animation: _editPageController.getAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return _buildSlideTransition(
                      child,
                      beginOffset: const Offset(-4, 0),
                    );
                  },
                  child: SvgPicture.asset(
                    kSettingIconPath,
                    height: kIconSize,
                    width: kIconSize,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await _editPageController.onTappedSaveButton();
                },
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                child: AnimatedBuilder(
                  animation: _editPageController.getAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return _buildSlideTransition(
                      child,
                      beginOffset: const Offset(4, 0),
                    );
                  },
                  child: SvgPicture.asset(
                    kSaveIconPath,
                    height: kIconSize,
                    width: kIconSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: kPrimaryColor,
          thickness: 1,
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            height: 120,
            child: AnimatedBuilder(
              animation: _editPageController.getAnimation,
              builder: (BuildContext context, Widget? child) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _editPageController.getAnimation,
                    curve: const Interval(
                      0.40,
                      0.70,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      if (_editPageController.assets.isNotEmpty)
                        VideoThumbnail(video: _editPageController.assets[0])
                      else
                        const VideoThumbnail(),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Stack(
                    children: [
                      if (_editPageController.assets.isNotEmpty)
                        VideoThumbnail(video: _editPageController.assets[1])
                      else
                        const VideoThumbnail(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          color: kPrimaryColor,
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }

  SlideTransition _buildSlideTransition(
    Widget? child, {
    required Offset beginOffset,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _editPageController.getAnimation,
          curve: const Interval(
            0,
            0.40,
            curve: Curves.easeInOutCubic,
          ),
        ),
      ),
      child: child,
    );
  }
}
