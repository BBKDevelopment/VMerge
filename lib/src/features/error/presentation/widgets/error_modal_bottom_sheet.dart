// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of 'error_listener.dart';

class _ErrorModalBottomSheet extends StatelessWidget {
  const _ErrorModalBottomSheet({
    required this.message,
    required this.error,
    required this.stackTrace,
  });

  final String message;
  final String error;
  final String stackTrace;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 28),
                    Assets.images.error.svg(
                      width: MediaQuery.of(context).size.height * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      highlightColor: Colors.transparent,
                      child: Assets.images.close.svg(
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Error',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 44),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 22),
                ExpansionTile(
                  collapsedIconColor: Theme.of(context).primaryColorLight,
                  iconColor: Theme.of(context).primaryColorLight,
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    RegExp("'(.*)'").firstMatch(error)?.group(1) ?? error,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'Exception Details',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  children: [
                    Text(
                      stackTrace,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
