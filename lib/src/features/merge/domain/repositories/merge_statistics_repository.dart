// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

abstract interface class MergeStatisticsRepository {
  const MergeStatisticsRepository();

  Future<DataState<MergeStatistics>> getMergeStatistics();

  Future<DataState<void>> saveMergeStatistics(MergeStatistics statistics);
}
