// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/core/core.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: context.textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_rounded),
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: context.l10n.appName,
              applicationIcon: Padding(
                padding: AppPadding.verticalMedium,
                child: Assets.images.vmerge.image(
                  width: AppIconSize.xxLarge,
                ),
              ),
              applicationVersion: getIt<PackageInfo>().version,
              applicationLegalese: context.l10n.copyrightMessage,
            );
          },
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(
          1,
        ),
        child: Divider(
          thickness: 1,
          height: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
