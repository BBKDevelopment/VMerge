// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class AnimatedControlButtonController {
  late Future<void> Function() forward;
  late Future<void> Function() reverse;
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
  late final AnimationController _animatedIconController;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animatedIconController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_animationController);
    _fadeAnimation =
        Tween<double>(begin: 1, end: 0).animate(_animationController);
    initController();
  }

  @override
  void dispose() {
    _animatedIconController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void initController() {
    widget.controller.forward = () async {
      if (!mounted) return;

      await Future.wait([
        _animatedIconController.forward(),
        _animationController.forward(from: 0),
      ]);
    };

    widget.controller.reverse = () async {
      if (!mounted) return;

      await Future.wait([
        _animatedIconController.reverse(),
        _animationController.forward(from: 0),
      ]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: _fadeAnimation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _scaleAnimation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: widget.size * 3,
          width: widget.size * 3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          alignment: Alignment.center,
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            progress: _animatedIconController,
            size: widget.size * 2,
          ),
        ),
      ),
    );
  }
}
