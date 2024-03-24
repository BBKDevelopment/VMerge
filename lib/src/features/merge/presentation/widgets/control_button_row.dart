part of '../pages/merge_page.dart';

class _ControlButtonRow extends StatelessWidget {
  const _ControlButtonRow({
    required this.animation,
  });

  final Animation<double> animation;

  void _onTapSettings(BuildContext context) {
    if (context.read<MergePageCubit>().state is! MergePageLoaded) return;

    context.read<MergePageCubit>().stopVideo();

    showCupertinoModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      topRadius: Radius.zero,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<MergePageCubit>(context),
        child: const Material(child: _SettingsModalBottomSheet()),
      ),
    );
  }

  void _onTapSaveVideo(BuildContext context) {
    if (context.read<MergePageCubit>().state is! MergePageLoaded) return;

    context.read<MergePageCubit>().stopVideo();
    // context.read<MergeCubit>().mergeVideos();

    showCupertinoModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      topRadius: Radius.zero,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<MergePageCubit>(context),
        child: const Material(child: _SaveModalBottomSheet()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(
                    0,
                    0.5,
                    curve: Curves.easeOut,
                  ),
                ),
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(
                        0,
                        0.5,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: FilledButton.tonalIcon(
              onPressed:
                  context.watch<MergePageCubit>().state is MergePageLoaded
                      ? () => _onTapSettings(context)
                      : null,
              label: Text(context.l10n.settings),
              icon: Hero(
                tag: 'settings',
                child: Assets.images.settings.svg(
                  height: AppIconSize.xSmall,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onSecondaryContainer,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: AppPadding.large,
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(
                    0,
                    0.7,
                    curve: Curves.easeOut,
                  ),
                ),
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(
                        0,
                        0.7,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: OutlinedButton.icon(
              onPressed:
                  context.watch<MergePageCubit>().state is MergePageLoaded
                      ? () => _onTapSaveVideo(context)
                      : null,
              label: Text(context.l10n.saveVideo),
              icon: Hero(
                tag: 'save',
                child: Assets.images.save.svg(
                  height: AppIconSize.xSmall,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onSecondaryContainer,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
