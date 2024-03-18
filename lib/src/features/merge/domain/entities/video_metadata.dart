// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

final class VideoMetadata extends Equatable {
  const VideoMetadata({
    required this.title,
    required this.duration,
    required this.thumbnail,
    required this.file,
  });

  final String? title;
  final int? duration;
  final Uint8List? thumbnail;
  final File? file;

  @override
  List<Object?> get props => [title, duration, thumbnail, file];
}
