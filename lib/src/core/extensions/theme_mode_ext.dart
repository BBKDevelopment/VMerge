// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

extension ThemeModeExt on ThemeMode {
  static ThemeMode fromString(String value) {
    final themeMode = ThemeMode.values.firstWhereOrNull(
      (videoResolution) => videoResolution.toString() == value,
    );

    return themeMode ?? ThemeMode.dark;
  }
}
