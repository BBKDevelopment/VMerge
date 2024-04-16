import 'package:flutter/material.dart';
import 'package:vmerge/src/config/config.dart';
import 'package:vmerge/src/core/core.dart';

/// {@template dark_app_theme}
/// An implementation of the [AppTheme] interface class that provides the dark
/// theme.
/// {@endtemplate}
final class DarkAppTheme implements AppTheme {
  /// {@macro dark_app_theme}
  DarkAppTheme(Color mainColor)
      : data = ThemeData(
          fontFamily: FontFamily.robotoMono,
          brightness: Brightness.dark,
          colorSchemeSeed: mainColor,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 57,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.25,
              height: 1.12,
            ),
            displayMedium: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1.15,
            ),
            displaySmall: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1.2,
            ),
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1.25,
            ),
            headlineMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1.28,
            ),
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1.33,
            ),
            titleLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1.27,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
              height: 1.5,
            ),
            titleSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              height: 1.42,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              height: 1.5,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
              height: 1.42,
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
              height: 1.33,
            ),
            labelLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              height: 1.42,
            ),
            labelMedium: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
              height: 1.33,
            ),
            labelSmall: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              height: 1.45,
            ),
          ),
        );

  @override
  final ThemeData data;
}
