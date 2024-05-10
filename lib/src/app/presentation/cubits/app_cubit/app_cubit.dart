// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/core/core.dart';

final class AppCubit extends Cubit<AppState> {
  AppCubit({
    required GetThemeConfigurationUseCase getThemeConfigurationUseCase,
    required SaveThemeConfigurationUseCase saveThemeConfigurationUseCase,
  })  : _getThemeConfigurationUseCase = getThemeConfigurationUseCase,
        _saveThemeConfigurationUseCase = saveThemeConfigurationUseCase,
        super(const AppInitializing());

  final GetThemeConfigurationUseCase _getThemeConfigurationUseCase;
  final SaveThemeConfigurationUseCase _saveThemeConfigurationUseCase;

  Future<void> init() async {
    final themeConfiguration = await _getThemeConfiguration();

    emit(
      AppInitialized(
        themeMode: ThemeModeExt.fromString(themeConfiguration.themeMode),
        mainColor: AppMainColor.fromString(themeConfiguration.mainColor),
      ),
    );
  }

  Future<ThemeConfiguration> _getThemeConfiguration() async {
    final dataState = await _getThemeConfigurationUseCase();

    switch (dataState) {
      case final DataSuccess<ThemeConfiguration> success:
        return success.data;
      case final DataFailure<ThemeConfiguration> failure:
        log(
          failure.message,
          name: failure.name,
          error: failure.error,
          stackTrace: failure.stackTrace,
        );
        final defaultThemeConfiguration = ThemeConfiguration(
          themeMode: '${ThemeMode.dark}',
          mainColor: '${AppMainColor.indigo}',
        );
        await _saveThemeConfiguration(defaultThemeConfiguration);
        return defaultThemeConfiguration;
    }
  }

  Future<void> _saveThemeConfiguration(
    ThemeConfiguration themeConfiguration,
  ) async {
    final dataState =
        await _saveThemeConfigurationUseCase(params: themeConfiguration);

    switch (dataState) {
      case DataSuccess():
        break;
      case final DataFailure<void> failure:
        log(
          failure.message,
          name: failure.name,
          error: failure.error,
          stackTrace: failure.stackTrace,
        );
    }
  }

  void _saveState() {
    switch (state) {
      case final AppInitialized state:
        final themeConfiguration = ThemeConfiguration(
          themeMode: state.themeMode.toString(),
          mainColor: state.mainColor.toString(),
        );

        _saveThemeConfiguration(themeConfiguration);
      default:
        break;
    }
  }

  void toggleThemeMode({required ThemeMode themeMode}) {
    switch (state) {
      case final AppInitialized state:
        emit(state.copyWith(themeMode: themeMode));
        _saveState();
      default:
        break;
    }
  }

  void updateMainColor({required AppMainColor mainColor}) {
    switch (state) {
      case final AppInitialized state:
        emit(state.copyWith(mainColor: mainColor));
        _saveState();
      default:
        break;
    }
  }
}
