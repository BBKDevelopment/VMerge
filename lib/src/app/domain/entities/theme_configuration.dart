import 'package:vmerge/src/core/core.dart';

final class ThemeConfiguration extends DomainEntity {
  const ThemeConfiguration({
    required this.themeMode,
    required this.mainColor,
  });

  final String themeMode;
  final String mainColor;

  @override
  List<Object?> get props => [themeMode, mainColor];
}
