import 'package:equatable/equatable.dart';
import 'package:vmerge/src/core/core.dart';

final class MoreState extends Equatable {
  const MoreState({
    required this.isDarkModeEnabled,
    required this.mainColor,
  });

  final bool isDarkModeEnabled;
  final AppMainColor mainColor;

  MoreState copyWith({
    bool? isDarkModeEnabled,
    AppMainColor? mainColor,
  }) {
    return MoreState(
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      mainColor: mainColor ?? this.mainColor,
    );
  }

  @override
  List<Object> get props => [isDarkModeEnabled, mainColor];
}
