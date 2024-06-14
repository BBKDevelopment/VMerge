// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

export 'local_merge_statistics_service.dart';
export 'object_box_merge_statistics_service.dart';

/// {@template merge_statistics_service}
/// An interface that defines the requirements for implementations that provide
/// merge statistics.
///
/// The [M] type is the model type.
/// {@endtemplate}
abstract interface class MergeStatisticsService<M> {
  /// {@macro merge_statistics_service}
  const MergeStatisticsService();

  Future<M> getMergeStatistics();

  Future<void> saveMergeStatistics(M statistics);
}
