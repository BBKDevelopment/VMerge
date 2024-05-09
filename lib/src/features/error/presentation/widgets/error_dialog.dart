// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of 'error_listener.dart';

class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog({
    required this.message,
    required this.error,
    required this.stackTrace,
  });

  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final showExpansionTile = kDebugMode && error != null && stackTrace != null;

    return AlertDialog(
      title: Text(
        l10n.error,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
          ),
          if (showExpansionTile) ...[
            const SizedBox(
              height: AppPadding.large,
            ),
            ExpansionTile(
              collapsedIconColor: context.theme.primaryColorLight,
              iconColor: context.theme.primaryColorLight,
              tilePadding: EdgeInsets.zero,
              // dense: true,
              title: Text(
                RegExp("'(.*)'").firstMatch('$error')?.group(1) ?? '$error',
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                l10n.exceptionDetail,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                SizedBox(
                  height: context.screenHeight * 0.3,
                  child: SingleChildScrollView(
                    child: Text(
                      '$stackTrace',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            l10n.close,
          ),
        ),
      ],
    );
  }
}
