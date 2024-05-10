// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vmerge/src/core/core.dart';

class NoVideoWarning extends StatelessWidget {
  const NoVideoWarning({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.horizontalMedium,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.error.svg(
            height: AppIconSize.large,
            colorFilter: ColorFilter.mode(
              context.colorScheme.error,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: AppPadding.xLarge,
          ),
          Text(
            context.l10n.selectTwoVideosMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(
            height: AppPadding.large,
          ),
          OutlinedButton(
            onPressed: onPressed,
            child: Text(
              context.l10n.openPicker,
            ),
          ),
        ],
      ),
    );
  }
}
