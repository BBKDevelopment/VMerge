// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

/// An abstract interface class that blueprints of the concrete theme
/// implementations.
abstract interface class AppTheme {
  /// Returns the [ThemeData] of the concrete theme implementations.
  ThemeData get data;
}
