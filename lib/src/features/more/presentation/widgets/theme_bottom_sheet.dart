part of '../pages/more_page.dart';

class _ThemeBottomSheet extends StatelessWidget {
  const _ThemeBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.allLarge,
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
                  onPressed: context.pop,
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
            context.l10n.theme,
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(
            height: AppPadding.xxLarge,
          ),
          const _ModeSelector(),
          const Divider(
            height: AppPadding.large,
          ),
          const _MainColorSelector(),
        ],
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return switch (state) {
          AppInitializing() => const SizedBox.shrink(),
          AppInitialized() => Row(
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
                      state.themeMode == ThemeMode.dark
                          ? context.l10n.on
                          : context.l10n.off,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.hintColor,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    context.read<AppCubit>().toggleThemeMode(
                          themeMode: value ? ThemeMode.dark : ThemeMode.light,
                        );
                  },
                ),
              ],
            ),
        };
      },
    );
  }
}

class _MainColorSelector extends StatelessWidget {
  const _MainColorSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return switch (state) {
          AppInitializing() => const SizedBox.shrink(),
          AppInitialized() => Row(
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
                    for (final color in AppMainColor.values)
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

                    context.read<AppCubit>().updateMainColor(mainColor: color);
                  },
                ),
              ],
            ),
        };
      },
    );
  }
}
