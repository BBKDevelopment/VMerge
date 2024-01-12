part of '../pages/edit_page.dart';

class _ControlButtons extends StatelessWidget {
  const _ControlButtons();

  void _onTapSettings(BuildContext context) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: context.read<EditCubit>().state is EditLoaded
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
        const SizedBox(
          width: AppPadding.large,
        ),
        Expanded(
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
      ],
    );
  }
}
