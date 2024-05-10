// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/core/core.dart';

final class GetThemeConfigurationUseCase
    implements UseCase<DataState<ThemeConfiguration>, void> {
  GetThemeConfigurationUseCase({
    required ThemeConfigurationRepository repository,
  }) : _repository = repository;

  final ThemeConfigurationRepository _repository;

  @override
  Future<DataState<ThemeConfiguration>> call({void params}) {
    return _repository.getThemeConfiguration();
  }
}
