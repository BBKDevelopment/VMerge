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
                      child: state.status == SaveBottomSheetStatus.success
                          ? const Icon(
                              Icons.check_rounded,
                              color: kPrimaryWhiteColor,
                              size: kIconSize,
                            )
                          : Text(
                              '${state.progress}%',
                              //'${_editPageController.progressPercentage.round()}%',
                              textAlign: TextAlign.center,
                              style: kBoldTextStyle.copyWith(
                                color: kPrimaryWhiteColor,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppPadding.large),
              Text(
                state.status.name,
                style: kMediumTextStyle,
              ),
            ],
          );
        },
      ),
    );
  }
}
