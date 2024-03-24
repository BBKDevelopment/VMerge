// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SaveModalBottomSheet extends StatelessWidget {
  const _SaveModalBottomSheet();

  @override
  Widget build(BuildContext context) {
    final status = context.select<MergePageCubit, SaveModalBottomSheetStatus>(
      (cubit) {
        switch (cubit.state) {
          case final MergePageLoaded state:
            return state.saveModalBottomSheetStatus;
          default:
            return SaveModalBottomSheetStatus.idle;
        }
      },
    );

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
                      if (status != SaveModalBottomSheetStatus.saved) return;

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
                    backgroundColor: kPrimaryWhiteColor.withOpacity(0.7),
                    strokeWidth: 8,
                    //value: _editPageController.progressPercentage / 100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.theme.iconTheme.color!,
                    ),
                  ),
                  Center(
                    child: status == SaveModalBottomSheetStatus.saved
                        ? const Icon(
                            Icons.check_rounded,
                            color: kPrimaryWhiteColor,
                            size: kIconSize,
                          )
                        : Text(
                            '', //'${_editPageController.progressPercentage.round()}%',
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
              status.name,
              style: kMediumTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
