// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class SaveMergeStatisticsUseCase
    implements UseCase<DataState<void>, MergeStatistics> {
  const SaveMergeStatisticsUseCase({
    required MergeStatisticsRepository repository,
  }) : _repository = repository;

  final MergeStatisticsRepository _repository;

  @override
  Future<DataState<void>> call({required MergeStatistics params}) {
    return _repository.saveMergeStatistics(params);
  }
}
