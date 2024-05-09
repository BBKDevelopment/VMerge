part of '../pages/merge_page.dart';

class _MergePageListener extends StatelessWidget {
  const _MergePageListener({
    required this.child,
    required this.controller,
  });

  final Widget child;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<MergePageCubit, MergePageState>(
      listener: (context, state) {
        switch (state) {
          case MergePageInitial():
            break;
          case MergePageLoading():
            controller.reset();
          case MergePageLoaded():
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.forward();
            });
          case MergePageError():
            switch (state.errorType) {
              case MergePageErrorType.insufficientVideoException:
                context.read<ErrorCubit>().caught(
                      message: l10n.twoVideosRequiredMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case MergePageErrorType.loadVideoException:
                context.read<ErrorCubit>().caught(
                      message: l10n.couldNotInitVideoPlayerMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case MergePageErrorType.playVideoException:
                context.read<ErrorCubit>().caught(
                      message: l10n.couldNotPlayVideoMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case MergePageErrorType.pauseVideoException:
                context.read<ErrorCubit>().caught(
                      message: l10n.couldNotPauseVideoMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case MergePageErrorType.setVideoPlaybackSpeedException:
                context.read<ErrorCubit>().caught(
                      message: l10n.couldNotSetVideoSpeedMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case MergePageErrorType.seekVideoPositionException:
                context.read<ErrorCubit>().caught(
                      message: l10n.couldNotSeekVideoPositionMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case MergePageErrorType.setVolumeException:
                context.read<ErrorCubit>().caught(
                      message: l10n.couldNotChangeVolumeMessage,
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
