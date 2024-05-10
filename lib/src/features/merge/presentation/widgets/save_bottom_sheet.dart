// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SaveBottomSheet extends StatefulWidget {
  const _SaveBottomSheet();

  @override
  State<_SaveBottomSheet> createState() => _SaveBottomSheetState();
}

class _SaveBottomSheetState extends State<_SaveBottomSheet> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsBottomSheetState = context
          .read<SettingsBottomSheetCubit>()
          .state as SettingsBottomSheetLoaded;

      context.read<SaveBottomSheetCubit>().mergeVideos(
            isAudioOn: settingsBottomSheetState.isAudioOn,
            speed: settingsBottomSheetState.playbackSpeed.value,
            outputWidth:
                settingsBottomSheetState.videoResolution.width?.toInt(),
            outputHeight:
                settingsBottomSheetState.videoResolution.height?.toInt(),
            forceFirstAspectRatio: settingsBottomSheetState.videoAspectRatio ==
                VideoAspectRatio.firstVideo,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _SaveBottomSheetListener(
      child: Padding(
        padding: AppPadding.allLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: AppButtonSize.small,
                ),
                Hero(
                  tag: 'save',
                  child: Assets.images.save.svg(
                    height: AppIconSize.xLarge,
                    colorFilter: ColorFilter.mode(
                      context.theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox.square(
                  dimension: AppButtonSize.small,
                  child: IconButton.filledTonal(
                    onPressed: () async {
                      final state = context.read<SaveBottomSheetCubit>().state;

                      switch (state) {
                        case SaveBottomSheetInitial():
                        case SaveBottomSheetAnalysing():
                        case SaveBottomSheetMerging():
                        case SaveBottomSheetSaving():
                          final shouldCancel = await showDialog<bool>(
                            context: context,
                            builder: (_) =>
                                const _SaveCancellationConfirmDialog(),
                          );
                          if (shouldCancel == null || !shouldCancel) return;

                          if (!context.mounted) return;
                          unawaited(
                            context.read<SaveBottomSheetCubit>().cancelMerge(),
                          );
                          context.pop();
                        case SaveBottomSheetSuccess():
                        case SaveBottomSheetCancelled():
                        case SaveBottomSheetError():
                          context.pop();
                      }
                    },
                    icon: Assets.images.close.svg(
                      height: AppIconSize.xxSmall,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.onSecondaryContainer,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppPadding.medium,
            ),
            Text(
              context.l10n.saveVideo,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(
              height: AppPadding.xxLarge,
            ),
            const _ProgressIndicator(),
            const SizedBox(
              height: AppPadding.large,
            ),
            const _Status(),
            const _StatusMessage(),
            const _GalleryButton(),
          ],
        ),
      ),
    );
  }
}

class _SaveBottomSheetListener extends StatelessWidget {
  const _SaveBottomSheetListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SaveBottomSheetCubit, SaveBottomSheetState>(
      listener: (context, state) {
        switch (state) {
          case SaveBottomSheetInitial():
          case SaveBottomSheetAnalysing():
          case SaveBottomSheetMerging():
          case SaveBottomSheetSaving():
          case SaveBottomSheetCancelled():
            break;
          case SaveBottomSheetSuccess():
            context.read<AppNavigationBarCubit>().resetIsSafeToNavigate();
          case SaveBottomSheetError():
            switch (state.errorType) {
              case SaveBottomSheetErrorType.readPermissionException:
                context.read<ErrorCubit>().caught(
                      message: l10n.permissionDeniedMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case SaveBottomSheetErrorType
                    .ffmpegServiceInitialisationException:
                context.read<ErrorCubit>().caught(
                      message: l10n.failedToInitFFmpegMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case SaveBottomSheetErrorType
                    .ffmpegServiceInsufficientVideosException:
                context.read<ErrorCubit>().caught(
                      message: l10n.twoVideosRequiredMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case SaveBottomSheetErrorType.ffmpegServiceMergeException:
                context.read<ErrorCubit>().caught(
                      message: l10n.failedToMergeVideosMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case SaveBottomSheetErrorType.saveException:
                context.read<ErrorCubit>().caught(
                      message: l10n.failedToSaveVideoMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
            }
        }
      },
      child: child,
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: BlocBuilder<SaveBottomSheetCubit, SaveBottomSheetState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                backgroundColor:
                    context.theme.iconTheme.color?.withOpacity(0.7),
                strokeWidth: 8,
                value: switch (state) {
                  SaveBottomSheetMerging() => state.progress / 100,
                  SaveBottomSheetSaving() || SaveBottomSheetSuccess() => 1.0,
                  _ => 0.0,
                },
                valueColor: AlwaysStoppedAnimation<Color>(
                  switch (state) {
                    SaveBottomSheetError() ||
                    SaveBottomSheetCancelled() =>
                      context.colorScheme.error,
                    _ => context.theme.iconTheme.color!,
                  },
                ),
              ),
              Center(
                child: switch (state) {
                  SaveBottomSheetInitial() => const SizedBox.shrink(),
                  SaveBottomSheetAnalysing() => Icon(
                      Icons.biotech_rounded,
                      color: context.theme.iconTheme.color,
                      size: AppIconSize.large,
                    ),
                  SaveBottomSheetMerging() => Text(
                      '${state.progress}%',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium,
                    ),
                  SaveBottomSheetSaving() => Icon(
                      Icons.downloading_rounded,
                      color: context.theme.iconTheme.color,
                      size: AppIconSize.large,
                    ),
                  SaveBottomSheetSuccess() => Icon(
                      Icons.check_rounded,
                      color: context.theme.iconTheme.color,
                      size: AppIconSize.large,
                    ),
                  SaveBottomSheetError() || SaveBottomSheetCancelled() => Icon(
                      Icons.close_rounded,
                      color: context.colorScheme.error,
                      size: AppIconSize.large,
                    ),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SaveBottomSheetCubit, SaveBottomSheetState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: AppAnimationDuration.medium,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            switch (state) {
              SaveBottomSheetInitial() => '',
              SaveBottomSheetAnalysing() => l10n.analyzing,
              SaveBottomSheetMerging() => l10n.merging,
              SaveBottomSheetSaving() => l10n.saving,
              SaveBottomSheetSuccess() => l10n.done,
              SaveBottomSheetCancelled() => l10n.cancelled,
              SaveBottomSheetError() => l10n.error,
            },
            key: ValueKey('$_Status:${state.runtimeType}'),
            style: context.textTheme.titleMedium,
          ),
        );
      },
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: 80,
      padding: AppPadding.horizontalLarge,
      child: BlocBuilder<SaveBottomSheetCubit, SaveBottomSheetState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: AppAnimationDuration.short,
            child: Text(
              switch (state) {
                SaveBottomSheetInitial() => '',
                SaveBottomSheetAnalysing() => l10n.analyzingMessage,
                SaveBottomSheetMerging() => l10n.mergingMessage,
                SaveBottomSheetSaving() => l10n.savingMessage,
                SaveBottomSheetSuccess() => l10n.doneMessage,
                SaveBottomSheetCancelled() => l10n.cancelledMessage,
                SaveBottomSheetError() => l10n.errorMessage,
              },
              key: ValueKey('$_StatusMessage:${state.runtimeType}'),
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}

class _GalleryButton extends StatelessWidget {
  const _GalleryButton();

  static const galleryIntent = AndroidIntent(
    action: 'android.intent.action.MAIN',
    category: 'android.intent.category.APP_GALLERY',
    flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SaveBottomSheetCubit, SaveBottomSheetState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: AppAnimationDuration.short,
          height: switch (state) {
            SaveBottomSheetSuccess() => kMinInteractiveDimension,
            _ => 0.0,
          },
          child: AnimatedOpacity(
            opacity: switch (state) {
              SaveBottomSheetSuccess() => 1.0,
              _ => 0.0,
            },
            duration: AppAnimationDuration.long,
            child: TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  try {
                    galleryIntent.launch();
                  } catch (error, stackTrace) {
                    log(
                      'Failed to launch gallery!',
                      name: '$_SaveBottomSheet',
                      error: error,
                      stackTrace: stackTrace,
                    );
                    context.read<ErrorCubit>().caught(
                          message: l10n.failedToLaunchGalleryMessage,
                          error: error,
                          stackTrace: stackTrace,
                        );
                  }
                }
              },
              child: Text(
                l10n.seeInTheGallery,
              ),
            ),
          ),
        );
      },
    );
  }
}
