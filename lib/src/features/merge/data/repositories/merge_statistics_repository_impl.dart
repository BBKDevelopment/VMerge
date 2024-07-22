// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class MergeStatisticsRepositoryImpl implements MergeStatisticsRepository {
  const MergeStatisticsRepositoryImpl({
    required LocalMergeStatisticsService localService,
  }) : _localService = localService;

  final LocalMergeStatisticsService _localService;

  @override
  Future<DataState<MergeStatistics>> getMergeStatistics() async {
    try {
      final localMergeStatistics = await _localService.getMergeStatistics();
      final mergeStatistics = localMergeStatistics.toEntity();
      return DataSuccess(mergeStatistics);
    } catch (error, stackTrace) {
      return DataFailure(
        Failure(
          'Could not get merge statistics!',
          error: error,
          name: '$MergeStatisticsRepositoryImpl',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> saveMergeStatistics(
    MergeStatistics statistics,
  ) async {
    try {
      final localMergeStatistics = LocalMergeStatistics.fromEntity(statistics);
      await _localService.saveMergeStatistics(localMergeStatistics);
      return const DataSuccess(null);
    } catch (error, stackTrace) {
      return DataFailure(
        Failure(
          'Could not save merge statistics!',
          error: error,
          name: '$MergeStatisticsRepositoryImpl',
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
