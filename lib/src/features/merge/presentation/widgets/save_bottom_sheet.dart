// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SaveBottomSheet extends StatefulWidget {
  const _SaveBottomSheet();

  @override
  State<_SaveBottomSheet> createState() => _SaveBottomSheetState();
}

class _SaveBottomSheetState extends State<_SaveBottomSheet> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SaveBottomSheetCubit>().mergeVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: AppPadding.allLarge,
      child: BlocBuilder<SaveBottomSheetCubit, SaveBottomSheetState>(
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
                    tag: 'save',
                    child: Assets.images.save.svg(
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
                context.l10n.saveVideo,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: AppPadding.xxLarge),
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor:
                          context.theme.iconTheme.color?.withOpacity(0.7),
                      strokeWidth: 8,
                      value: state.progress / 100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        switch (state.status) {
                          SaveBottomSheetStatus.error =>
                            context.colorScheme.error,
                          _ => context.theme.iconTheme.color!,
                        },
                      ),
                    ),
                    Center(
                      child: switch (state.status) {
                        SaveBottomSheetStatus.success => Icon(
                            Icons.check_rounded,
                            color: context.theme.iconTheme.color,
                            size: AppIconSize.large,
                          ),
                        SaveBottomSheetStatus.error => Icon(
                            Icons.close_rounded,
                            color: context.colorScheme.error,
                            size: AppIconSize.large,
                          ),
                        _ => Text(
                            '${state.progress}%',
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleMedium,
                          ),
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppPadding.large),
              AnimatedSwitcher(
                duration: AppAnimationDuration.medium,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  switch (state.status) {
                    SaveBottomSheetStatus.analyse => l10n.analyzing,
                    SaveBottomSheetStatus.merge => l10n.merging,
                    SaveBottomSheetStatus.save => l10n.saving,
                    SaveBottomSheetStatus.success => l10n.done,
                    SaveBottomSheetStatus.error => l10n.error,
                  },
                  key: ValueKey('title:${state.status.name}'),
                  style: context.textTheme.titleMedium,
                ),
              ),
              Container(
                height: 80,
                padding: AppPadding.horizontalLarge,
                child: AnimatedSwitcher(
                  duration: AppAnimationDuration.short,
                  child: Text(
                    switch (state.status) {
                      SaveBottomSheetStatus.analyse => l10n.analyzingMessage,
                      SaveBottomSheetStatus.merge => l10n.mergingMessage,
                      SaveBottomSheetStatus.save => l10n.savingMessage,
                      SaveBottomSheetStatus.success => l10n.doneMessage,
                      SaveBottomSheetStatus.error => l10n.errorMessage,
                    },
                    key: ValueKey('subtitle:${state.status.name}'),
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: AppAnimationDuration.short,
                height: switch (state.status) {
                  SaveBottomSheetStatus.success => kMinInteractiveDimension,
                  _ => 0.0,
                },
                child: AnimatedOpacity(
                  opacity: switch (state.status) {
                    SaveBottomSheetStatus.success => 1.0,
                    _ => 0.0,
                  },
                  duration: AppAnimationDuration.long,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(l10n.seeInTheGallery),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
