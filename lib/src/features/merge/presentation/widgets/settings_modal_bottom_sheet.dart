// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SettingsModalBottomSheet extends StatelessWidget {
  const _SettingsModalBottomSheet();

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
                  tag: 'settings',
                  child: Assets.images.settings.svg(
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
              context.l10n.settings,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: AppPadding.xxLarge),
            const _SoundSelector(),
            const Divider(height: AppPadding.large),
            const _ResolutionSelector(),
          ],
        ),
      ),
    );
  }
}

class _SoundSelector extends StatelessWidget {
  const _SoundSelector();

  @override
  Widget build(BuildContext context) {
    final isSoundOn = context.select<MergeCubit, bool>((cubit) {
      final state = cubit.state;
      if (state is MergeLoaded) return state.isSoundOn;

      return false;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.sound,
              style: context.textTheme.bodyMedium,
            ),
            Text(
              context.l10n.on,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
          ],
        ),
        Switch(
          value: isSoundOn,
          onChanged: (isSoundOn) {
            context.read<MergeCubit>().toggleSound(isSoundOn: isSoundOn);
          },
        ),
      ],
    );
  }
}

class _ResolutionSelector extends StatelessWidget {
  const _ResolutionSelector();

  String getSubtitle(BuildContext context, Resolution? resolution) {
    if (resolution == null) return '';

    final width = resolution.width?.toInt();
    final height = resolution.height?.toInt();

    if (width == null || height == null) return context.l10n.original;

    return '${width}x$height';
  }

  @override
  Widget build(BuildContext context) {
    final resolution = context.select<MergeCubit, Resolution?>((cubit) {
      final state = cubit.state;
      if (state is MergeLoaded) return state.resolution;

      return null;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.resolution,
              style: context.textTheme.bodyMedium,
            ),
            Text(
              getSubtitle(context, resolution),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
          ],
        ),
        DropdownButton(
          items: [
            for (final resolution in Resolution.values)
              DropdownMenuItem(
                value: resolution,
                alignment: Alignment.center,
                child: Text(
                  resolution == Resolution.original
                      ? context.l10n.original
                      : resolution.value,
                ),
              ),
          ],
          value: resolution,
          onChanged: (resolution) {
            if (resolution == null) return;

            context.read<MergeCubit>().changeResolution(resolution);
          },
          underline: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _SpeedSelector extends StatelessWidget {
  const _SpeedSelector();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.sound,
              style: context.textTheme.bodyMedium,
            ),
            Text(
              context.l10n.on,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
          ],
        ),
        Switch(
          value: true,
          onChanged: (value) {},
        ),
      ],
    );
  }
}
