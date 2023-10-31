// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vmerge/models/models.dart';

abstract class VideoService {
  Future<List<Video>> getAll(BuildContext context);
}
