// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SaveModalBottomSheet extends StatelessWidget {
  const _SaveModalBottomSheet();

  @override
  Widget build(BuildContext context) {
    final status = context.select<MergeCubit, SaveModalBottomSheetStatus>(
      (cubit) {
        switch (cubit.state) {
          case final MergeLoaded state:
            return state.saveModalBottomSheetStatus;
          default:
            return SaveModalBottomSheetStatus.idle;
        }
      },
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: kIconSize),
                  const Text(
                    kSaveToAlbumText,
                    style: kBoldTextStyle,
                  ),
                  InkWell(
                    onTap: () {
                      if (status != SaveModalBottomSheetStatus.saved) return;

                      Navigator.of(context).pop();
                    },
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    child: status == SaveModalBottomSheetStatus.saved
                        ? SvgPicture.asset(
                            kCloseIconPath,
                            width: kIconSize,
                            color: kPrimaryWhiteColor.withOpacity(1),
                          )
                        : const SizedBox(width: kIconSize),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: kPrimaryWhiteColor.withOpacity(0.7),
                      strokeWidth: 8,
                      //value: _editPageController.progressPercentage / 100,
                      valueColor: const AlwaysStoppedAnimation(
                        kPrimaryWhiteColor,
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
              const SizedBox(height: 32),
              Text(
                status.name,
                style: kMediumTextStyle,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
