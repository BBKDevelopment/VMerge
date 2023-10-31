// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/models/models.dart';
import 'package:vmerge/utilities/utilities.dart';

class EditPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final FlutterFFmpeg _flutterFFmpeg;
  late final FlutterFFmpegConfig _fFmpegConfig;
  late final VideoPlayerOptions _videoPlayerOptions;
  late final AnimationController _animationController;
  late final Animation<double> _staggeredAnimation;
  late final RxDouble _speedValue;
  late final RxDouble _qualityValue;
  late final RxDouble _progressPercentage;
  late final RxList<Video> _assets;
  late final List<File> _file;
  late final RxString _status;
  late final RxInt _currentVideo;
  late final RxBool _isVideoPlaying;
  late VideoPlayerController _videoPlayerController;
  late VideoPlayerController _videoPlayerControllerTwo;
  late RxBool isVideoReady;
  late String _speedValueText;
  late String _qualityValueText;
  late RxInt _selectedSoundIndex;
  late bool _needRefresh;

  VideoPlayerController get videoPlayerController => _videoPlayerController;
  VideoPlayerController get videoPlayerControllerTwo =>
      _videoPlayerControllerTwo;
  AnimationController get getAnimationController => _animationController;
  Animation<double> get getAnimation => _staggeredAnimation;
  List<Video> get assets => _assets;
  List<File> get file => _file;
  int get currentVideo => _currentVideo.value;
  int get selectedSoundIndex => _selectedSoundIndex.value;
  String get speedValueText => _speedValueText;
  String get qualityValueText => _qualityValueText;
  String get status => _status.value;
  double get progressPercentage => _progressPercentage.value;
  double get speedValue => _speedValue.value;
  double get qualityValue => _qualityValue.value;
  bool get needRefresh => _needRefresh;
  bool get isVideoPlaying => _isVideoPlaying.value;

  @override
  void onInit() {
    super.onInit();
    _animationController = AnimationController(
      vsync: this,
      duration: kEditPageInAnimationDuration,
    );
    _staggeredAnimation = Tween(begin: 0.toDouble(), end: 1.toDouble())
        .animate(_animationController);

    _flutterFFmpeg = FlutterFFmpeg();
    _fFmpegConfig = FlutterFFmpegConfig();
    _videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
    _file = <File>[];
    _assets = <Video>[].obs;
    _isVideoPlaying = false.obs;
    _speedValue = 3.0.obs;
    _qualityValue = 6.0.obs;
    _progressPercentage = 0.0.obs;
    _status = ''.obs;
    _currentVideo = 1.obs;
    isVideoReady = false.obs;
    _speedValueText = '1.00';
    _qualityValueText = 'Default';
    _selectedSoundIndex = 0.obs;
    _needRefresh = false;
    _videoPlayerController = VideoPlayerController.asset('');
    _videoPlayerControllerTwo = VideoPlayerController.asset('');
  }

  @override
  void onClose() {
    _videoPlayerController.dispose();
    _videoPlayerControllerTwo.dispose();
    _animationController.dispose();
    _flutterFFmpeg.cancel();
    super.dispose();
  }

  Future<void> setFile(File? fileOne, File? fileTwo) async {
    if (fileOne == null) return;
    if (fileTwo == null) return;
    _file.clear();
    _file.add(fileOne);
    _file.add(fileTwo);
  }

  Future<void> close() async {
    if (_file.isEmpty) return;
    _isVideoPlaying.value = false;
    _removeVideoListener();
    _selectedSoundIndex = 0.obs;
    isVideoReady.value = false;
    await _videoPlayerController.dispose();
    await _videoPlayerControllerTwo.dispose();
  }

  Future<void> initVideoPlayer() async {
    if (_file.isEmpty) return;
    _videoPlayerController = VideoPlayerController.file(
      _file[0],
      videoPlayerOptions: _videoPlayerOptions,
    );
    _currentVideo.value = 1;
    await _videoPlayerController.initialize();
    _videoPlayerControllerTwo = VideoPlayerController.file(
      _file[1],
      videoPlayerOptions: _videoPlayerOptions,
    );
    await _videoPlayerControllerTwo.initialize();
    _removeVideoListener();
    _selectedSoundIndex.value = 0;
    _speedValue.value = 3.0;
    _speedValueText = '1.00';
    isVideoReady.value = true;
  }

  void _addVideoListener() {
    _videoPlayerController.addListener(() async {
      if (_videoPlayerController.value.position.inSeconds ==
          _videoPlayerController.value.duration.inSeconds) {
        _currentVideo.value = 2;
        await _videoPlayerController.seekTo(Duration.zero);
        await _videoPlayerController.pause();
        await _videoPlayerControllerTwo.play();
      }
    });

    _videoPlayerControllerTwo.addListener(() async {
      if (_videoPlayerControllerTwo.value.position.inSeconds ==
          _videoPlayerControllerTwo.value.duration.inSeconds) {
        _currentVideo.value = 1;
        await _videoPlayerControllerTwo.seekTo(Duration.zero);
        await _videoPlayerControllerTwo.pause();
        _isVideoPlaying.value = false;
      }
    });
  }

  void _removeVideoListener() {
    _videoPlayerController.removeListener(() async {
      if (_videoPlayerController.value.position.inSeconds ==
          _videoPlayerController.value.duration.inSeconds) {
        _currentVideo.value = 2;
        await _videoPlayerController.seekTo(Duration.zero);
        await _videoPlayerController.pause();
        await _videoPlayerControllerTwo.play();
      }
    });

    _videoPlayerControllerTwo.removeListener(() async {
      if (_videoPlayerControllerTwo.value.position.inSeconds ==
          _videoPlayerControllerTwo.value.duration.inSeconds) {
        _currentVideo.value = 1;
        await _videoPlayerControllerTwo.seekTo(Duration.zero);
        await _videoPlayerControllerTwo.pause();
        _isVideoPlaying.value = false;
      }
    });
  }

  Future<void> _stopVideo() async {
    _isVideoPlaying.value = false;
    _removeVideoListener();
    if (currentVideo == 1) {
      await _videoPlayerController.pause();
    } else {
      await _videoPlayerControllerTwo.pause();
    }
  }

  Future<void> onTappedPlayButton() async {
    if (_isVideoPlaying.value) {
      await _stopVideo();
    } else {
      _isVideoPlaying.value = true;
      _addVideoListener();
      if (currentVideo == 1) {
        await _videoPlayerController.play();
      } else {
        await _videoPlayerControllerTwo.play();
      }
    }
  }

  Future<void> setSpeed(double speed) async {
    switch (speed.round()) {
      case 0:
        _speedValueText = '0.25';
        await _videoPlayerController.setPlaybackSpeed(0.25);
        await _videoPlayerControllerTwo.setPlaybackSpeed(0.25);
      case 1:
        _speedValueText = '0.50';
        await _videoPlayerController.setPlaybackSpeed(0.50);
        await _videoPlayerControllerTwo.setPlaybackSpeed(0.50);
      case 2:
        _speedValueText = '0.75';
        await _videoPlayerController.setPlaybackSpeed(0.75);
        await _videoPlayerControllerTwo.setPlaybackSpeed(0.75);
      case 3:
        _speedValueText = '1.00';
        await _videoPlayerController.setPlaybackSpeed(1);
        await _videoPlayerControllerTwo.setPlaybackSpeed(1);
      case 4:
        _speedValueText = '1.25';
        await _videoPlayerController.setPlaybackSpeed(1.25);
        await _videoPlayerControllerTwo.setPlaybackSpeed(1.25);
      case 5:
        _speedValueText = '1.50';
        await _videoPlayerController.setPlaybackSpeed(1.50);
        await _videoPlayerControllerTwo.setPlaybackSpeed(1.50);
      case 6:
        _speedValueText = '1.75';
        await _videoPlayerController.setPlaybackSpeed(1.75);
        await _videoPlayerControllerTwo.setPlaybackSpeed(1.75);
      case 7:
        _speedValueText = '2.00';
        await _videoPlayerController.setPlaybackSpeed(2);
        await _videoPlayerControllerTwo.setPlaybackSpeed(2);
      default:
        break;
    }
    _currentVideo.value = 1;
    await _videoPlayerController.seekTo(Duration.zero);
    await _videoPlayerControllerTwo.seekTo(Duration.zero);
    _speedValue.value = speed;
  }

  void setQuality(double quality) {
    switch (quality.round()) {
      case 0:
        _qualityValueText = '240p';
      case 1:
        _qualityValueText = '480p';
      case 2:
        _qualityValueText = '720p';
      case 3:
        _qualityValueText = '1080p';
      case 4:
        _qualityValueText = '1440p';
      case 5:
        _qualityValueText = '2160p';
      case 6:
        _qualityValueText = 'Default';
      default:
        break;
    }
    _qualityValue.value = quality;
  }

  Future<void> onTappedSettingsButton() async {
    if (!isVideoReady.value) return;
    await _stopVideo();
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      useRootNavigator: true,
      elevation: 4,
      builder: (context) => SettingsModalBottomSheet(),
    );
  }

  Future<void> _callSaveBottomSheet() async {
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      useRootNavigator: true,
      elevation: 4,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SaveModalBottomSheet(),
      ),
    );
  }

  Future<void> onTappedSaveButton() async {
    if (!isVideoReady.value) return;
    await _stopVideo();

    _status.value = kWaitText;
    await _callSaveBottomSheet();
    await _execFFmpeg();
  }

  Future<void> _execFFmpeg() async {
    var rc = 0;

    Directory appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = (await getExternalStorageDirectory())!;
    }

    final safeOriginalVideoPath = '"${_file[0].path}"';
    final safeOriginalSecondVideoPath = '"${_file[1].path}"';

    final finalVideoPath = join(
      appDocDirectory.path,
      'Video-${DateTime.now().millisecondsSinceEpoch}.mp4',
    );
    final safeFinalVideoPath = '"$finalVideoPath"';

    final editedFinalVideoPath = join(
      appDocDirectory.path,
      'FinalVideo-${DateTime.now().millisecondsSinceEpoch}.mp4',
    );
    final safeEditedFinalVideoPath = '"$editedFinalVideoPath"';

    final firstTempVideoPath = join(appDocDirectory.path, 'Temp-Video-1.mp4');
    final safeFirstTempVideoPath = '"$firstTempVideoPath"';

    final secondTempVideoPath = join(appDocDirectory.path, 'Temp-Video-2.mp4');
    final safeSecondTempVideoPath = '"$secondTempVideoPath"';

    final qualityCommand = _qualityValueText == 'Default'
        ? ''
        : '-vf scale=${_qualityValueText.substring(0, _qualityValueText.length - 1)}:-2,setsar=1:1';

    final speedCommand = _videoPlayerController.value.playbackSpeed == 1.0
        ? ''
        : '-filter_complex '
            '"[0:v]setpts=PTS/${_videoPlayerController.value.playbackSpeed}[v]; [0:a]atempo=${_videoPlayerController.value.playbackSpeed}[a]" '
            '-map '
            '"[v]" '
            '-map '
            '"[a]"';

    final concatCommand =
        '"concat:$safeFirstTempVideoPath|$safeSecondTempVideoPath"';

    double tempPercentage;

    await _fFmpegConfig.enableStatistics();
    _fFmpegConfig.enableStatisticsCallback((statistics) {
      tempPercentage = (statistics.time / 10) /
          (videoPlayerController.value.duration.inSeconds +
              videoPlayerControllerTwo.value.duration.inSeconds);
      _progressPercentage.value = tempPercentage > 100 ? 100 : tempPercentage;
    });

    try {
      await _flutterFFmpeg.execute(
        '-i $safeOriginalVideoPath -y -c copy -bsf:v h264_mp4toannexb -f mpegts $safeFirstTempVideoPath',
      );
      await _flutterFFmpeg.execute(
        '-i $safeOriginalSecondVideoPath -y -c copy -bsf:v h264_mp4toannexb -f mpegts $safeSecondTempVideoPath',
      );

      _status.value = kMergeText;
      if (qualityCommand != '') {
        rc = await _flutterFFmpeg.execute(
          '-i $concatCommand -y -bsf:a aac_adtstoasc $qualityCommand $safeFinalVideoPath',
        );
      } else {
        rc = await _flutterFFmpeg.execute(
          '-i $concatCommand -y -c copy -bsf:a aac_adtstoasc $safeFinalVideoPath',
        );
      }

      if (speedCommand != '') {
        _status.value = kCompressText;
        rc = await _flutterFFmpeg.execute(
          '-i $safeFinalVideoPath -y -safe 0 -vcodec libx264 -crf 18 $speedCommand $safeEditedFinalVideoPath',
        );
      }
    } on Exception catch (exception) {
      debugPrint('Try Catch for FFMPEG Execution $exception');
    } catch (error) {
      debugPrint('Try Catch for FFMPEG Execution $error');
    }

    if (speedCommand != '') {
      await _saveToGallery(
        videoPath: finalVideoPath,
        firstTempVideoPath: firstTempVideoPath,
        secondTempVideoPath: secondTempVideoPath,
        finalVideoPath: editedFinalVideoPath,
      );
    } else {
      await _saveToGallery(
        firstTempVideoPath: firstTempVideoPath,
        secondTempVideoPath: secondTempVideoPath,
        finalVideoPath: finalVideoPath,
      );
    }

    _progressPercentage.value = 100.0;
    _status.value = kSuccessText;

    _needRefresh = rc == 0 ? true : false;
    await _fFmpegConfig.disableStatistics();
  }

  void setRefresh(bool state) {
    _needRefresh = false;
  }

  Future<void> _saveToGallery({
    required String firstTempVideoPath,
    required String secondTempVideoPath,
    required String finalVideoPath,
    String videoPath = '',
  }) async {
    //ToDo: Başarı durumu için ayrı bir kontrol yapılıp olumsuz icon gösterilerilebilinir.
    await ImageGallerySaver.saveFile(finalVideoPath);
    try {
      final dirVideo = Directory(videoPath);
      final dirFirstTemp = Directory(firstTempVideoPath);
      final dirSecondTemp = Directory(secondTempVideoPath);
      final dirFinalVideo = Directory(finalVideoPath);
      dirVideo.deleteSync(recursive: true);
      dirFirstTemp.deleteSync(recursive: true);
      dirSecondTemp.deleteSync(recursive: true);
      dirFinalVideo.deleteSync(recursive: true);
    } on Exception catch (exception) {
      debugPrint(exception.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void updateAssets(List<Video> assets) {
    _assets.assignAll(assets);
  }
}
