// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

export 'local_theme_configuration_service.dart';
export 'object_box_theme_configuration_service.dart';

abstract interface class ThemeConfigurationService<M> {
  const ThemeConfigurationService();

  Future<M> getThemeConfiguration();

  Future<void> saveThemeConfiguration(M configuration);
}
