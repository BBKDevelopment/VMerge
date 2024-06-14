// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/features/merge/merge.dart';

/// {@template local_merge_statistics_service}
/// An interface that inherits from [MergeStatisticsService] and defines the
/// requirements for implementations that use a local service.
///
/// The [LocalMergeStatistics] type is the model type.
/// {@endtemplate}
abstract interface class LocalMergeStatisticsService
    implements MergeStatisticsService<LocalMergeStatistics> {
  /// {@macro local_merge_statistics_service}
  const LocalMergeStatisticsService();
}
