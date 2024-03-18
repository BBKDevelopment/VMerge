// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

part of '../pages/more_page.dart';

class _CopyrightText extends StatelessWidget {
  const _CopyrightText({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(
              0,
              1,
              curve: Curves.easeOut,
            ),
          ),
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, -0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(
                  0,
                  1,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: child,
          ),
        );
      },
      child: Text(
        context.l10n.copyrightMessage,
        style: context.textTheme.labelSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
