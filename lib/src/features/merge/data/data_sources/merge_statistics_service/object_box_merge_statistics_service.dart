// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class ObjectBoxMergeStatisticsService
    implements LocalMergeStatisticsService {
  /// {@macro object_box_merge_statistics_service}
  const ObjectBoxMergeStatisticsService({required ObjectBoxService service})
      : _service = service;

  final ObjectBoxService _service;

  /// Gets the [LocalMergeStatistics].
  @override
  Future<LocalMergeStatistics> getMergeStatistics() async {
    final box = _service.store.box<LocalMergeStatistics>();
    final query = box.query().build();
    final entities = query.find();
    final statistics = entities.first;
    query.close();

    return statistics;
  }

  /// Saves the [LocalMergeStatistics].
  @override
  Future<void> saveMergeStatistics(LocalMergeStatistics statistics) async {
    final box = _service.store.box<LocalMergeStatistics>();
    final query = box.query().build();
    final entities = query.find();
    final oldStatistics = entities.firstOrNull;
    query.close();

    if (oldStatistics != null) statistics.id = oldStatistics.id;

    box.put(statistics);
  }
}
