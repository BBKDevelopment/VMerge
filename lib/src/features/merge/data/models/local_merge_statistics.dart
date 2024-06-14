// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/domain/domain.dart';

@Entity()
final class LocalMergeStatistics implements DataModel<MergeStatistics> {
  LocalMergeStatistics();

  LocalMergeStatistics.fromArgs({
    required this.successMerges,
    required this.failedMerges,
  });

  LocalMergeStatistics.fromEntity(MergeStatistics entity)
      : this.fromArgs(
          successMerges: entity.successMerges,
          failedMerges: entity.failedMerges,
        );

  int id = 0;
  int successMerges = 0;
  int failedMerges = 0;

  @override
  MergeStatistics toEntity() {
    return MergeStatistics(
      successMerges: successMerges,
      failedMerges: failedMerges,
    );
  }
}
