// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:collection/collection.dart';
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
    return switch (this) {
      red => Colors.red,
      pink => Colors.pink,
      purple => Colors.purple,
      indigo => Colors.indigo,
      blue => Colors.blue,
      cyan => Colors.cyan,
      teal => Colors.teal,
      green => Colors.green,
      lime => Colors.lime,
      yellow => Colors.yellow,
      orange => Colors.orange,
      brown => Colors.brown,
    };
  }

  @override
  String toString() {
    return name;
  }

  static AppMainColor fromString(String value) {
    final appMainColor = AppMainColor.values.firstWhereOrNull(
      (appMainColor) => appMainColor.toString() == value,
    );

    return appMainColor ?? AppMainColor.indigo;
  }
}
