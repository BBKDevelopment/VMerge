import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

final class MoreState extends Equatable {
  const MoreState({
    required this.isDarkModeEnabled,
    required this.mainColor,
  });

  final bool isDarkModeEnabled;
  final Color mainColor;

  MoreState copyWith({
    bool? isDarkModeEnabled,
    Color? mainColor,
  }) {
    return MoreState(
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      mainColor: mainColor ?? this.mainColor,
    );
  }

  @override
  List<Object> get props => [isDarkModeEnabled, mainColor];
}
