import 'package:flutter/material.dart';

/// An abstract interface class that blueprints of the concrete theme
/// implementations.
abstract interface class AppTheme {
  /// Returns the [ThemeData] of the concrete theme implementations.
  ThemeData get data;
}
