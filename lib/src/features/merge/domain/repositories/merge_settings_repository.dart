// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

abstract interface class MergeSettingsRepository {
  const MergeSettingsRepository();

  Future<DataState<MergeSettings>> getMergeSettings();

  Future<DataState<void>> saveMergeSettings(MergeSettings settings);
}
