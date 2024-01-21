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
            const SizedBox(height: AppPadding.large),
            const _AspectRatioSelector(),
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

  String getSubtitle(BuildContext context, VideoResolution? resolution) {
    if (resolution == null) return '';

    final width = resolution.width?.toInt();
    final height = resolution.height?.toInt();

    if (width == null || height == null) return context.l10n.original;

    return '${width}x$height';
  }

  @override
  Widget build(BuildContext context) {
    final resolution = context.select<MergeCubit, VideoResolution?>((cubit) {
      final state = cubit.state;
      if (state is MergeLoaded) return state.videoResolution;

      return null;
    });

    return Row(
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
        const Spacer(),
        if (resolution == VideoResolution.original)
          Tooltip(
            message: context.l10n.originalResolutionTooltip,
            triggerMode: TooltipTriggerMode.tap,
            child: Icon(
              Icons.info_outline,
              size: AppIconSize.small,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(width: AppPadding.small),
        CustomDropdownButton(
          items: [
            for (final resolution in VideoResolution.values)
              DropdownMenuItem(
                value: resolution,
                alignment: Alignment.center,
                child: Text(
                  resolution == VideoResolution.original
                      ? context.l10n.original
                      : resolution.value,
                ),
              ),
          ],
          value: resolution,
          tooltip: getSubtitle(context, resolution),
          onChanged: (resolution) {
            if (resolution == null) return;

            context.read<MergeCubit>().changeVideoResolution(resolution);
          },
        ),
      ],
    );
  }
}

class _AspectRatioSelector extends StatelessWidget {
  const _AspectRatioSelector();

  String getSubtitle(BuildContext context, VideoAspectRatio? ratio) {
    if (ratio == null) return '';

    String getAutoSubtitle() {
      final state = context.watch<MergeCubit>().state;
      if (state is! MergeLoaded) return '';

      return state.videoResolution.aspectRatio ?? '';
    }

    return switch (ratio) {
      VideoAspectRatio.independent => context.l10n.independent,
      VideoAspectRatio.firstVideo => context.l10n.firstVideo,
      VideoAspectRatio.auto => getAutoSubtitle(),
    };
  }

  String getTooltip(BuildContext context, VideoAspectRatio? ratio) {
    if (ratio == null) return '';

    return switch (ratio) {
      VideoAspectRatio.independent =>
        context.l10n.independentAspectRatioTooltip,
      VideoAspectRatio.firstVideo => context.l10n.firstAspectRatioTooltip,
      VideoAspectRatio.auto => context.l10n.autoAspectRatioTooltip,
    };
  }

  String getDropdownLabel(BuildContext context, VideoAspectRatio? ratio) {
    if (ratio == null) return '';

    return switch (ratio) {
      VideoAspectRatio.independent => context.l10n.independent,
      VideoAspectRatio.firstVideo => context.l10n.firstVideo,
      VideoAspectRatio.auto => context.l10n.auto,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ratio = context.select<MergeCubit, VideoAspectRatio?>((cubit) {
      final state = cubit.state;
      if (state is MergeLoaded) return state.videoAspectRatio;

      return null;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.aspectRatio,
              style: context.textTheme.bodyMedium,
            ),
            Text(
              getSubtitle(context, ratio),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
          ],
        ),
        const Spacer(),
        Tooltip(
          message: getTooltip(context, ratio),
          triggerMode: TooltipTriggerMode.tap,
          child: Icon(
            Icons.info_outline,
            size: AppIconSize.small,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: AppPadding.small),
        CustomDropdownButton(
          items: [
            for (final ratio in VideoAspectRatio.values)
              DropdownMenuItem(
                value: ratio,
                enabled: ratio != VideoAspectRatio.auto,
                child: Text(getDropdownLabel(context, ratio)),
              ),
          ],
          value: ratio,
          enabled: ratio != VideoAspectRatio.auto,
          tooltip: getTooltip(context, ratio),
          onChanged: (ratio) {
            if (ratio == null) return;

            context.read<MergeCubit>().changeVideoAspectRatio(ratio);
          },
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
