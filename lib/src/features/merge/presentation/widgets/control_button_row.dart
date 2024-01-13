part of '../pages/merge_page.dart';

class _ControlButtonRow extends StatelessWidget {
  const _ControlButtonRow({
    required this.animation,
  });

  final Animation<double> animation;

  void _onTapSettings(BuildContext context) {
    if (context.read<MergeCubit>().state is! MergeLoaded) return;

    context.read<MergeCubit>().stopVideo();

    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      useRootNavigator: true,
      elevation: 4,
      builder: (_) => const _SettingsModalBottomSheet(),
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
              onPressed: context.read<MergeCubit>().state is MergeLoaded
                  ? () => _onTapSettings(context)
                  : null,
              label: Text(context.l10n.settings),
              icon: Assets.images.settings.svg(
                height: AppIconSize.xSmall,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.onSecondaryContainer,
                  BlendMode.srcIn,
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
              onPressed: null,
              label: Text(context.l10n.saveVideo),
              icon: Assets.images.save.svg(
                height: AppIconSize.xSmall,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.onSecondaryContainer,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
