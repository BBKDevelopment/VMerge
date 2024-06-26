// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/merge_page.dart';

class _SaveCancellationConfirmDialog extends StatelessWidget {
  const _SaveCancellationConfirmDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(
        l10n.confirm,
      ),
      content: Text(
        l10n.saveCancellationConfirmMessage,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(
            l10n.no,
          ),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(
            l10n.yes,
          ),
        ),
      ],
    );
  }
}
