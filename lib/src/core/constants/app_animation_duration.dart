// Copyright 2022 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

/// A class that provides constant animation duration values to use app-wide.
abstract final class AppAnimationDuration {
  /// [short] duration equals to `400 milliseconds`.
  static const short = Duration(milliseconds: 600);

  /// [medium] duration equals to `600 milliseconds`.
  static const medium = Duration(milliseconds: 800);

  /// [long] duration equals to `1000 milliseconds`.
  static const long = Duration(milliseconds: 1000);
}
