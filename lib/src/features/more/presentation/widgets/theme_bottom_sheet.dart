part of '../pages/more_page.dart';

class _ThemeBottomSheet extends StatelessWidget {
  const _ThemeBottomSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                const SizedBox(width: IconSize.medium),
                Hero(
                  tag: MorePageOption.theme.name,
                  child: Assets.images.palette.svg(
                    height: IconSize.xLarge,
                    colorFilter: ColorFilter.mode(
                      context.theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                InkWell(
                  onTap: Navigator.of(context).pop,
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  highlightColor: Colors.transparent,
                  child: Assets.images.close.svg(
                    height: IconSize.medium,
                    colorFilter: ColorFilter.mode(
                      context.theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppPadding.medium),
            Text(
              l10n.theme,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.darkMode,
          style: context.textTheme.bodyMedium,
        ),
        BlocBuilder<MoreCubit, MoreState>(
          builder: (context, state) {
            return Switch(
              value: state.isDarkModeEnabled,
              onChanged: (value) {
                context
                    .read<MoreCubit>()
                    .toggleDarkMode(isDarkModeEnabled: value);
              },
            );
          },
        ),
      ],
    );
  }
}

class _MainColorSelector extends StatelessWidget {
  const _MainColorSelector();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.mainColor,
          style: context.textTheme.bodyMedium,
        ),
        BlocBuilder<MoreCubit, MoreState>(
          builder: (context, state) {
            return DropdownButton(
              items: [
                for (final color in AppColor.values)
                  DropdownMenuItem(
                    value: color.value,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.circle,
                      color: color.value,
                      size: IconSize.medium,
                    ),
                  ),
              ],
              value: state.mainColor,
              onChanged: (color) {
                if (color == null) return;

                context.read<MoreCubit>().updateMainColor(mainColor: color);
              },
              underline: const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
