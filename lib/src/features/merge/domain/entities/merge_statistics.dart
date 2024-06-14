// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';

final class MergeStatistics extends DomainEntity {
  const MergeStatistics({
    required this.successMerges,
    required this.failedMerges,
  });

  final int successMerges;
  final int failedMerges;

  @override
  String toString() {
    return 'MergeStatistics(successMerges: $successMerges, failedMerges: '
        '$failedMerges)';
  }

  @override
  List<Object> get props => [
        successMerges,
        failedMerges,
      ];

  MergeStatistics copyWith({int? successMerges, int? failedMerges}) {
    return MergeStatistics(
      successMerges: successMerges ?? this.successMerges,
      failedMerges: failedMerges ?? this.failedMerges,
    );
  }
}
