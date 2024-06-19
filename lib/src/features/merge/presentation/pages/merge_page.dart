// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:ffmpeg_service/ffmpeg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review_service/in_app_review_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/components/components.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/error/error.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:wakelock_service/wakelock_service.dart';

part '../widgets/control_button_row.dart';
part '../widgets/merge_page_listener.dart';
part '../widgets/save_bottom_sheet.dart';
part '../widgets/save_cancellation_confirm_dialog.dart';
part '../widgets/selected_video_list.dart';
part '../widgets/settings_bottom_sheet.dart';
part '../widgets/settings_warning_dialog.dart';
part '../widgets/video_player.dart';
part '../widgets/video_thumbnail.dart';

class MergePage extends StatelessWidget {
  const MergePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MergePageCubit(
            firstVideoPlayerService: getIt<VideoPlayerService>(),
            secondVideoPlayerService: getIt<VideoPlayerService>(),
            thirdVideoPlayerService: getIt<VideoPlayerService>(),
            fourthVideoPlayerService: getIt<VideoPlayerService>(),
          ),
        ),
        BlocProvider(
          create: (_) => SettingsBottomSheetCubit(
            getMergeSettingsUseCase: getIt<GetMergeSettingsUseCase>(),
            saveMergeSettingsUseCase: getIt<SaveMergeSettingsUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => SaveBottomSheetCubit(
            ffmpegService: getIt<FFmpegService>(),
            wakelockService: getIt<WakelockService>(),
            inAppReviewService: getIt<InAppReviewService>(),
            getMergeStatisticsUseCase: getIt<GetMergeStatisticsUseCase>(),
            saveMergeStatisticsUseCase: getIt<SaveMergeStatisticsUseCase>(),
          ),
        ),
      ],
      child: const _MergeView(),
    );
  }
}

class _MergeView extends StatefulWidget {
  const _MergeView();

  @override
  State<_MergeView> createState() => _MergeViewState();
}

class _MergeViewState extends State<_MergeView> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late final AnimatedControlButtonController _animatedControlButtonController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimationDuration.long,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animatedControlButtonController = AnimatedControlButtonController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SettingsBottomSheetCubit>().init();
      if (!mounted) return;

      unawaited(_animationController.forward());

      final videoMetadatas = context.read<AppNavigationBarCubit>().state.args;
      if (videoMetadatas == null) return;
      if (videoMetadatas is! List<VideoMetadata>) return;

      final settingsBottomSheetState = context
          .read<SettingsBottomSheetCubit>()
          .state as SettingsBottomSheetLoaded;
      await context.read<MergePageCubit>().loadVideoMetadata(
            videoMetadatas,
            isSoundOn: settingsBottomSheetState.isAudioOn,
          );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MergePageListener(
      controller: _animationController,
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.appName),
        body: Padding(
          padding: AppPadding.general,
          child: Column(
            children: [
              Expanded(
                child: _VideoPlayer(
                  animation: _animation,
                  animatedControlButtonController:
                      _animatedControlButtonController,
                ),
              ),
              const SizedBox(
                height: AppPadding.medium,
              ),
              _ControlButtonRow(
                animation: _animation,
              ),
              const SizedBox(
                height: AppPadding.medium,
              ),
              _SelectedVideoList(
                animation: _animation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
