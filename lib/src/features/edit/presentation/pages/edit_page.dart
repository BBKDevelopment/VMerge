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
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/edit/edit.dart';
import 'package:vmerge/utilities/utilities.dart';

part '../widgets/save_modal_bottom_sheet.dart';
part '../widgets/settings_modal_bottom_sheet.dart';
part '../widgets/video_player.dart';
part '../widgets/video_thumbnail.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditCubit(
        const EditInitial(),
        firstVideoPlayerService: getIt<VideoPlayerService>(),
        secondVideoPlayerService: getIt<VideoPlayerService>(),
      ),
      child: const _EditView(),
    );
  }
}

class _EditView extends StatefulWidget {
  const _EditView();

  @override
  State<_EditView> createState() => _EditViewState();
}

class _EditViewState extends State<_EditView> with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapSettings() {
    if (context.read<EditCubit>().state is! EditLoaded) return;

    context.read<EditCubit>().stopVideo();

    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      useRootNavigator: true,
      elevation: 4,
      builder: (_) => const SettingsModalBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.appName),
      body: Padding(
        padding: AppPadding.general,
        child: Column(
          children: [
            Flexible(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animation,
                      curve: const Interval(
                        0.70,
                        1,
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                    child: child,
                  );
                },
                child: BlocConsumer<EditCubit, EditState>(
                  listener: (context, state) {
                    switch (state) {
                      case EditInitial():
                        break;
                      case EditLoading():
                        break;
                      case EditLoaded():
                        break;
                      case EditError():
                        break;
                    }
                  },
                  buildWhen: (previous, current) {
                    if (previous is EditError) return false;
                    if (current is EditError) return false;

                    return true;
                  },
                  builder: (context, state) {
                    switch (state) {
                      case EditInitial():
                        return Center(
                          child: Text(
                            kSelectVideoText,
                            style: context.textTheme.bodyMedium,
                            textAlign: TextAlign.justify,
                          ),
                        );
                      case EditLoading():
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case EditLoaded():
                        return _VideoPlayer(
                          videoPlayerController: state.videoPlayerController,
                          animatedControlButtonController:
                              _animatedControlButtonController,
                          videoWidth: state.videoWidth,
                          videoHeight: state.videoHeight,
                          onTap: () {
                            if (state.isVideoPlaying) {
                              context.read<EditCubit>().stopVideo();
                            } else {
                              context.read<EditCubit>().playVideo();
                            }
                          },
                        );
                      case EditError():
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
            _buildControlPanel(context),
          ],
        ),
      ),
    );
  }

  Column _buildControlPanel(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppPadding.medium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: context.read<EditCubit>().state is EditLoaded
                    ? _onTapSettings
                    : null,
                label: const Text('Settings'),
                icon: Assets.images.settings.svg(
                  height: AppIconSize.xSmall,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onSecondaryContainer,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: AppPadding.large,
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: context.read<EditCubit>().state is EditLoaded
                    ? _onTapSettings
                    : null,
                label: const Text('Save Video'),
                icon: Assets.images.save.svg(
                  height: AppIconSize.xSmall,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onSecondaryContainer,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppPadding.medium),
        SizedBox(
          height: 120,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animation,
                  curve: const Interval(
                    0.40,
                    0.70,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
                child: child,
              );
            },
            child: BlocSelector<EditCubit, EditState, List<VideoMetadata>>(
              selector: (state) {
                if (state is! EditLoaded) return [];

                return state.metadatas;
              },
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        if (state.isNotEmpty)
                          VideoThumbnail(metadata: state.first)
                        else
                          const VideoThumbnail(),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Stack(
                      children: [
                        if (state.isNotEmpty)
                          VideoThumbnail(metadata: state.last)
                        else
                          const VideoThumbnail(),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
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
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animation,
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
