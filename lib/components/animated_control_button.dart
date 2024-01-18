// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class AnimatedControlButtonController {
  late void Function() forward;
  late void Function() reverse;
}

class AnimatedControlButton extends StatefulWidget {
  const AnimatedControlButton({
    required this.controller,
    this.onTap,
    this.size = 32.0,
    super.key,
  });

  final AnimatedControlButtonController controller;
  final void Function()? onTap;
  final double size;

  @override
  State<AnimatedControlButton> createState() => _AnimatedControlButtonState();
}

class _AnimatedControlButtonState extends State<AnimatedControlButton>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    initController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initController() {
    widget.controller.forward = () async {
      if (mounted) {
        await controller.forward();
      }
    };

    widget.controller.reverse = () async {
      if (mounted) {
        await controller.reverse();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: widget.size * 1.4,
        width: widget.size * 1.4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        alignment: Alignment.center,
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          progress: controller,
          size: widget.size,
        ),
      ),
    );
  }
}
