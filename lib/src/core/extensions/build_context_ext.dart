// Copyright 2022 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vmerge/src/core/core.dart';

/// Extension for [BuildContext] to add more capabilities to it.
extension BuildContextExt on BuildContext {
  /// Provides direct access to localization.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Provides direct access to theme data.
  ThemeData get theme => Theme.of(this);

  /// Provides direct access to text theme.
  TextTheme get textTheme => theme.textTheme;

  /// Provides direct access to color scheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Provides direct access to the height of the screen.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Provides direct access to the width of the screen.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Provides direct access to pop operation of the navigator.
  void pop<T extends Object?>([T? result]) =>
      Navigator.of(this).pop<T?>(result);
}
