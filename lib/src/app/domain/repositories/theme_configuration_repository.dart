// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/core/core.dart';

abstract interface class ThemeConfigurationRepository {
  const ThemeConfigurationRepository();

  Future<DataState<ThemeConfiguration>> getThemeConfiguration();

  Future<DataState<void>> saveThemeConfiguration(
    ThemeConfiguration configuration,
  );
}
