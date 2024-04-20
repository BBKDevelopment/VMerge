// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SettingsBottomSheet extends StatelessWidget {
  const _SettingsBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.allLarge,
      child: BlocConsumer<SettingsBottomSheetCubit, SettingsBottomSheetState>(
        listener: (context, state) {
          context.read<MergePageCubit>().setVideoSpeedAndSound(
                speed: state.playbackSpeed,
                isSoundOn: state.isSoundOn,
              );
        },
        builder: (context, state) {
          return Column(
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
                context.l10n.settings,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(
                height: AppPadding.xxLarge,
              ),
              _SoundSelector(
                isSoundOn: state.isSoundOn,
              ),
              const Divider(
                height: AppPadding.large,
              ),
              _ResolutionSelector(
                state.videoResolution,
              ),
              const SizedBox(
                height: AppPadding.large,
              ),
              _AspectRatioSelector(
                state.videoAspectRatio,
                state.videoResolution,
              ),
              const Divider(
                height: AppPadding.large,
              ),
              _SpeedSelector(
                state.playbackSpeed,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SoundSelector extends StatelessWidget {
  const _SoundSelector({required this.isSoundOn});

  final bool isSoundOn;

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
              isSoundOn ? context.l10n.on : context.l10n.off,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
          ],
        ),
        Switch(
          value: isSoundOn,
          onChanged: (isSoundOn) {
            context
                .read<SettingsBottomSheetCubit>()
                .toggleSound(isSoundOn: isSoundOn);
          },
        ),
      ],
    );
  }
}

class _ResolutionSelector extends StatelessWidget {
  const _ResolutionSelector(this.resolution);

  final VideoResolution resolution;

  String getSubtitle(BuildContext context, VideoResolution? resolution) {
    if (resolution == null) return '';

    final width = resolution.width?.toInt();
    final height = resolution.height?.toInt();

    if (width == null || height == null) return context.l10n.original;

    return '${width}x$height';
  }

  @override
  Widget build(BuildContext context) {
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
              color: context.colorScheme.onSurface,
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

            context
                .read<SettingsBottomSheetCubit>()
                .changeVideoResolution(resolution);
          },
        ),
      ],
    );
  }
}

class _AspectRatioSelector extends StatelessWidget {
  const _AspectRatioSelector(this.aspectRatio, this.resolution);

  final VideoAspectRatio aspectRatio;
  final VideoResolution resolution;

  String getSubtitle(BuildContext context, VideoAspectRatio? ratio) {
    if (ratio == null) return '';

    return switch (ratio) {
      VideoAspectRatio.independent => context.l10n.independent,
      VideoAspectRatio.firstVideo => context.l10n.firstVideo,
      VideoAspectRatio.auto => resolution.aspectRatio ?? '',
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
              getSubtitle(context, aspectRatio),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
          ],
        ),
        const Spacer(),
        Tooltip(
          message: getTooltip(context, aspectRatio),
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
          value: aspectRatio,
          enabled: aspectRatio != VideoAspectRatio.auto,
          tooltip: getTooltip(context, aspectRatio),
          onChanged: (ratio) {
            if (ratio == null) return;

            context
                .read<SettingsBottomSheetCubit>()
                .changeVideoAspectRatio(ratio);
          },
        ),
      ],
    );
  }
}

class _SpeedSelector extends StatelessWidget {
  const _SpeedSelector(this.speed);

  final PlaybackSpeed speed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.playbackSpeed,
              style: context.textTheme.bodyMedium,
            ),
            Text(
              '${speed.value}x',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
          child: Slider(
            value: speed.value,
            onChanged: (value) {
              final speed = PlaybackSpeed.fromValue(value);
              if (speed == null) return;

              context
                  .read<SettingsBottomSheetCubit>()
                  .changePlaybackSpeed(speed);
            },
            min: PlaybackSpeed.zeroPointFive.value,
            max: PlaybackSpeed.two.value,
            divisions: PlaybackSpeed.values.length - 1,
          ),
        ),
      ],
    );
  }
}
