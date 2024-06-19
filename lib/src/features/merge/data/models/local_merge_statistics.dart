// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/domain/domain.dart';

@Entity()
final class LocalMergeStatistics implements DataModel<MergeStatistics> {
  LocalMergeStatistics();

  LocalMergeStatistics.fromArgs({
    required this.successMergeCount,
    required this.failedMergeCount,
  });

  LocalMergeStatistics.fromEntity(MergeStatistics entity)
      : this.fromArgs(
          successMergeCount: entity.successMergeCount,
          failedMergeCount: entity.failedMergeCount,
        );

  int id = 0;
  int successMergeCount = 0;
  int failedMergeCount = 0;

  @override
  MergeStatistics toEntity() {
    return MergeStatistics(
      successMergeCount: successMergeCount,
      failedMergeCount: failedMergeCount,
    );
  }
}
