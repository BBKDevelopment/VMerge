// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/components/components.dart';
import 'package:vmerge/src/components/no_video_warning.dart';
import 'package:vmerge/src/core/constants/app_border_radius.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';
import 'package:vmerge/utilities/utilities.dart';

part '../widgets/control_button_row.dart';
part '../widgets/save_modal_bottom_sheet.dart';
part '../widgets/selected_video_list.dart';
part '../widgets/settings_modal_bottom_sheet.dart';
part '../widgets/video_player.dart';
part '../widgets/video_thumbnail.dart';

class MergePage extends StatelessWidget {
  const MergePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MergeCubit(
        const MergeInitial(),
        firstVideoPlayerService: getIt<VideoPlayerService>(),
        secondVideoPlayerService: getIt<VideoPlayerService>(),
      ),
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
      duration: kEditPageInAnimationDuration,
    )..forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animatedControlButtonController = AnimatedControlButtonController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videoMetadatas = context.read<NavigationCubit>().state.arguments;
      if (videoMetadatas == null) return;
      if (videoMetadatas is! List<VideoMetadata>) return;

      context.read<MergeCubit>().loadVideoMetadatas(videoMetadatas);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.appName),
      body: Padding(
        padding: AppPadding.general,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animation,
                      curve: const Interval(
                        0,
                        0.3,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, -0.05),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animation,
                          curve: const Interval(
                            0,
                            0.3,
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: BlocConsumer<MergeCubit, MergeState>(
                  listener: (context, state) {
                    switch (state) {
                      case MergeInitial():
                        break;
                      case MergeLoading():
                        _animationController.reset();
                      case MergeLoaded():
                        _animationController.forward();
                      case MergeError():
                        break;
                    }
                  },
                  buildWhen: (previous, current) {
                    if (previous is MergeError) return false;
                    if (current is MergeError) return false;

                    return true;
                  },
                  builder: (context, state) {
                    switch (state) {
                      case MergeInitial():
                        return NoVideoWarning(
                          onPressed: () => context
                              .read<NavigationCubit>()
                              .updatePage(NavigationBarPage.previewVideo),
                        );
                      case MergeLoading():
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case MergeLoaded():
                        return _VideoPlayer(
                          videoPlayerController: state.videoPlayerController,
                          animatedControlButtonController:
                              _animatedControlButtonController,
                          videoWidth: state.videoWidth,
                          videoHeight: state.videoHeight,
                          onTap: () {
                            if (state.isVideoPlaying) {
                              context.read<MergeCubit>().stopVideo();
                            } else {
                              context.read<MergeCubit>().playVideo();
                            }
                          },
                        );
                      case MergeError():
                        return const SizedBox.shrink();
                    }
                  },
                ),
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
    );
  }
}
