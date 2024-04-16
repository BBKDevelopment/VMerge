// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

// ignore_for_file: prefer_const_constructors

import 'package:ffmpeg_service/ffmpeg_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FFmpegService', () {
    test('can be instantiated', () {
      expect(FFmpegService(), isNotNull);
    });
  });
}
