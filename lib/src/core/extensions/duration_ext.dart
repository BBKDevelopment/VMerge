// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

/// Extension for [Duration] to add more capabilities to it.
extension DurationExt on Duration {
  /// Returns the duration in the format of `hh:mm:ss`. If the duration is less
  /// than an hour, it will return `mm:ss`.
  ///
  /// Example:
  /// ```dart
  /// final duration = Duration(minutes: 5, seconds: 30);
  /// print(duration.format); // 05:30
  ///
  /// final duration = Duration(hours: 2, minutes: 5, seconds: 30);
  /// print(duration.format); // 02:05:30
  /// ```
  String get format {
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final hours = inHours.remainder(60).toString().padLeft(2, '0');
    return hours != '00' ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  /// Returns the duration in the format of `hh:mm:ss`.
  ///
  /// Example:
  /// ```dart
  /// final duration = Duration(hours: 2, minutes: 5, seconds: 30);
  /// print(duration.formatHhMmSs); // 02:05:30
  /// ```
  String get formatHhMmSs {
    final time = toString().split('.').first.padLeft(8, '0');
    return time;
  }
}
