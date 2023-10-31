// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

class Video {
  Video({
    required this.title,
    required this.duration,
    required this.image,
    required this.file,
  });

  final String? title;
  final int? duration;
  final Uint8List? image;
  final File? file;
}
