part of '../pages/video_select_page.dart';

class _VideoSelectPageListener extends StatelessWidget {
  const _VideoSelectPageListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<VideoSelectPageCubit, VideoSelectPageState>(
      listener: (context, state) {
        switch (state) {
          case VideoSelectPageLoading():
            break;
          case VideoSelectPageLoaded():
            break;
          case VideoSelectPageError():
            switch (state.errorType) {
              case VideoSelectPageErrorType.insufficientVideoException:
                context.read<ErrorCubit>().caught(
                      message: l10n.twoVideosRequiredMessage,
                      error: state.error,
                      stackTrace: state.stackTrace,
                    );
              case VideoSelectPageErrorType.loadingVideoException:
                context.read<ErrorCubit>().caught(
                      message: l10n.couldNotLoadVideosMessage,
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
