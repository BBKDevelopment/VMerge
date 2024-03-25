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
        super(
          AppState(
            themeMode: ThemeModeExt.fromString(
              _defaultThemeConfiguration.themeMode,
            ),
            mainColor: AppMainColor.fromString(
              _defaultThemeConfiguration.mainColor,
            ),
          ),
        );

  final GetThemeConfigurationUseCase _getThemeConfigurationUseCase;
  final SaveThemeConfigurationUseCase _saveThemeConfigurationUseCase;

  static const _defaultThemeConfiguration = ThemeConfiguration(
    themeMode: 'dark',
    mainColor: 'indigo',
  );

  Future<void> init() async {
    final themeConfiguration = await _getThemeConfiguration();

    emit(
      state.copyWith(
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
        await _saveThemeConfiguration(_defaultThemeConfiguration);
        return _defaultThemeConfiguration;
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

  void _saveStateAsThemeConfiguration() {
    final themeConfiguration = ThemeConfiguration(
      themeMode: state.themeMode.toString(),
      mainColor: state.mainColor.toString(),
    );

    _saveThemeConfiguration(themeConfiguration);
  }

  void toggleThemeMode({required ThemeMode themeMode}) {
    emit(state.copyWith(themeMode: themeMode));
    _saveStateAsThemeConfiguration();
  }

  void updateMainColor({required AppMainColor mainColor}) {
    emit(state.copyWith(mainColor: mainColor));
    _saveStateAsThemeConfiguration();
  }
}
