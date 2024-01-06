import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class AppState extends Equatable {
  const AppState({
    required this.themeMode,
    required this.mainColor,
  });

  final ThemeMode themeMode;
  final Color mainColor;

  AppState copyWith({
    ThemeMode? themeMode,
    Color? mainColor,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      mainColor: mainColor ?? this.mainColor,
    );
  }

  @override
  List<Object> get props => [themeMode, mainColor];
}
