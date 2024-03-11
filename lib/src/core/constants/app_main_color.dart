// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

/// An enum that provides constant main color values to use app-wide.
enum AppMainColor {
  /// [red] color value equals to `Colors.red`.
  red,

  /// [pink] color value equals to `Colors.pink`.
  pink,

  /// [purple] color value equals to `Colors.purple`.
  purple,

  /// [indigo] color value equals to `Colors.indigo`.
  indigo,

  /// [blue] color value equals to `Colors.blue`.
  blue,

  /// [cyan] color value equals to `Colors.cyan`.
  cyan,

  /// [teal] color value equals to `Colors.teal`.
  teal,

  /// [green] color value equals to `Colors.green`.
  green,

  /// [lime] color value equals to `Colors.lime`.
  lime,

  /// [yellow] color value equals to `Colors.yellow`.
  yellow,

  /// [orange] color value equals to `Colors.orange`.
  orange,

  /// [brown] color value equals to `Colors.brown`.
  brown;

  /// Returns [Color] based on the enum value.
  Color get value {
    switch (this) {
      case red:
        return Colors.red;
      case pink:
        return Colors.pink;
      case purple:
        return Colors.purple;
      case indigo:
        return Colors.indigo;
      case blue:
        return Colors.blue;
      case cyan:
        return Colors.cyan;
      case teal:
        return Colors.teal;
      case green:
        return Colors.green;
      case lime:
        return Colors.lime;
      case yellow:
        return Colors.yellow;
      case orange:
        return Colors.orange;
      case brown:
        return Colors.brown;
    }
  }
}
