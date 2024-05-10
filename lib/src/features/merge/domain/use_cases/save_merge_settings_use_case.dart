// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class SaveMergeSettingsUseCase
    implements UseCase<DataState<void>, MergeSettings> {
  const SaveMergeSettingsUseCase({
    required MergeSettingsRepository repository,
  }) : _repository = repository;

  final MergeSettingsRepository _repository;

  @override
  Future<DataState<void>> call({required MergeSettings params}) {
    return _repository.saveMergeSettings(params);
  }
}
