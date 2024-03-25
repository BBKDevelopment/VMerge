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
