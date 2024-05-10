// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/core/core.dart';

final class ThemeConfigurationRepositoryImpl
    implements ThemeConfigurationRepository {
  ThemeConfigurationRepositoryImpl({
    required LocalThemeConfigurationService localService,
  }) : _localService = localService;

  final LocalThemeConfigurationService _localService;

  @override
  Future<DataState<ThemeConfiguration>> getThemeConfiguration() async {
    try {
      final localThemeConfiguration =
          await _localService.getThemeConfiguration();
      final themeConfiguration = localThemeConfiguration.toEntity();
      return DataSuccess(themeConfiguration);
    } catch (error, stackTrace) {
      return DataFailure(
        Failure(
          'Could not get theme configuration!',
          error: error,
          name: '$ThemeConfigurationRepositoryImpl',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> saveThemeConfiguration(
    ThemeConfiguration configuration,
  ) async {
    try {
      final localThemeConfiguration =
          LocalThemeConfiguration.fromEntity(configuration);
      await _localService.saveThemeConfiguration(localThemeConfiguration);
      return const DataSuccess(null);
    } catch (error, stackTrace) {
      return DataFailure(
        Failure(
          'Could not save theme configuration!',
          error: error,
          name: '$ThemeConfigurationRepositoryImpl',
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
