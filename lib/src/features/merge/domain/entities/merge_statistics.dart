// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';

final class MergeStatistics extends DomainEntity {
  const MergeStatistics({
    required this.successMergeCount,
    required this.failedMergeCount,
  });

  final int successMergeCount;
  final int failedMergeCount;

  @override
  String toString() {
    return 'MergeStatistics(successMergeCount: $successMergeCount, '
        'failedMergeCount: $failedMergeCount)';
  }

  @override
  List<Object> get props => [
        successMergeCount,
        failedMergeCount,
      ];

  MergeStatistics copyWith({int? successMergeCount, int? failedMergeCount}) {
    return MergeStatistics(
      successMergeCount: successMergeCount ?? this.successMergeCount,
      failedMergeCount: failedMergeCount ?? this.failedMergeCount,
    );
  }
}
