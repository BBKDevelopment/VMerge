// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SettingsWarningDialog extends StatelessWidget {
  const _SettingsWarningDialog({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(
        l10n.warning,
      ),
      content: Text(
        message,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(
            l10n.close,
          ),
        ),
      ],
    );
  }
}
