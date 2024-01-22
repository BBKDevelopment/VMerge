part of '../pages/more_page.dart';

class _ThemeBottomSheet extends StatelessWidget {
  const _ThemeBottomSheet();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.theme.dividerColor),
        ),
      ),
      child: Padding(
        padding: AppPadding.general,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: AppButtonSize.small),
                Hero(
                  tag: MorePageOption.theme.name,
                  child: Assets.images.palette.svg(
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
                    onPressed: Navigator.of(context).pop,
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
            const SizedBox(height: AppPadding.medium),
            Text(
              context.l10n.theme,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: AppPadding.xxLarge),
            const _ModeSelector(),
            const Divider(height: AppPadding.large),
            const _MainColorSelector(),
          ],
        ),
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.darkMode,
                  style: context.textTheme.bodyMedium,
                ),
                Text(
                  state.isDarkModeEnabled ? context.l10n.on : context.l10n.off,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.hintColor,
                  ),
                ),
              ],
            ),
            Switch(
              value: state.isDarkModeEnabled,
              onChanged: (value) {
                context
                    .read<MoreCubit>()
                    .toggleDarkMode(isDarkModeEnabled: value);
              },
            ),
          ],
        );
      },
    );
  }
}

class _MainColorSelector extends StatelessWidget {
  const _MainColorSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.mainColor,
                  style: context.textTheme.bodyMedium,
                ),
                Text(
                  state.mainColor.name(context),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.hintColor,
                  ),
                ),
              ],
            ),
            CustomDropdownButton(
              items: [
                for (final color in AppColor.values)
                  DropdownMenuItem(
                    value: color,
                    child: Center(
                      child: Icon(
                        Icons.circle,
                        color: color.value,
                        size: AppIconSize.medium,
                      ),
                    ),
                  ),
              ],
              value: state.mainColor,
              onChanged: (color) {
                if (color == null) return;

                context.read<MoreCubit>().updateMainColor(mainColor: color);
              },
            ),
          ],
        );
      },
    );
  }
}
