import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vmerge/src/core/core.dart';

sealed class AppState extends Equatable {
  const AppState();
}

final class AppInitializing extends AppState {
  const AppInitializing();

  @override
  List<Object?> get props => [];
}

final class AppInitialized extends AppState {
  const AppInitialized({
    required this.themeMode,
    required this.mainColor,
  });

  final ThemeMode themeMode;
  final AppMainColor mainColor;

  AppInitialized copyWith({
    ThemeMode? themeMode,
    AppMainColor? mainColor,
  }) {
    return AppInitialized(
      themeMode: themeMode ?? this.themeMode,
      mainColor: mainColor ?? this.mainColor,
    );
  }

  @override
  List<Object?> get props => [themeMode, mainColor];
}
