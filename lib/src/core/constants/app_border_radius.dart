// Copyright 2022 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that provides constant border radius values to use app-wide.
abstract final class AppBorderRadius {
  /// [xSmall] radius equals to `2.0`.
  static const xSmall = 2.0;

  /// [small] radius equals to `4.0`.
  static const small = 4.0;

  /// [medium] radius equals to `8.0`.
  static const medium = 8.0;

  /// [large] radius equals to `12.0`.
  static const large = 12.0;

  /// [xLarge] radius equals to `16.0`.
  static const xLarge = 16.0;

  /// [xxLarge] radius equals to `24.0`.
  static const xxLarge = 24.0;

  /// [xxxLarge] radius equals to `32.0`.
  static const xxxLarge = 32.0;

  /// Returns [BorderRadius] that is circular with a radius of `2.0`.
  static BorderRadius get circularXSmall =>
      const BorderRadius.all(Radius.circular(xSmall));

  /// Returns [BorderRadius] that is circular with a radius of `4.0`.
  static BorderRadius get circularSmall =>
      const BorderRadius.all(Radius.circular(small));

  /// Returns [BorderRadius] that is circular with a radius of `8.0`.
  static BorderRadius get circularMedium =>
      const BorderRadius.all(Radius.circular(medium));

  /// Returns [BorderRadius] that is circular with a radius of `12.0`.
  static BorderRadius get circularLarge =>
      const BorderRadius.all(Radius.circular(large));

  /// Returns [BorderRadius] that is circular with a radius of `16.0`.
  static BorderRadius get circularXLarge =>
      const BorderRadius.all(Radius.circular(xLarge));

  /// Returns [BorderRadius] that is circular with a radius of `24.0`.
  static BorderRadius get circularXXLarge =>
      const BorderRadius.all(Radius.circular(xxLarge));

  /// Returns [BorderRadius] that is circular with a radius of `32.0`.
  static BorderRadius get circularXXXLarge =>
      const BorderRadius.all(Radius.circular(xxxLarge));
}
