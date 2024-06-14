// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class GetMergeStatisticsUseCase
    implements UseCase<DataState<MergeStatistics>, void> {
  const GetMergeStatisticsUseCase({
    required MergeStatisticsRepository repository,
  }) : _repository = repository;

  final MergeStatisticsRepository _repository;

  @override
  Future<DataState<MergeStatistics>> call({void params}) {
    return _repository.getMergeStatistics();
  }
}
