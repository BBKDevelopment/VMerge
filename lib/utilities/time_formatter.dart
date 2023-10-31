// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

class TimeFormatter {
  static String format({required Duration duration}) {
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours.remainder(60).toString().padLeft(2, '0');
    return hours != '00' ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  static String formatHHmmss({required Duration duration}) {
    final time = duration.toString().split('.').first.padLeft(8, '0');
    return time;
  }
}
