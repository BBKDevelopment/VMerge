import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/core/core.dart';

@Entity()
final class LocalThemeConfiguration implements DataModel<ThemeConfiguration> {
  LocalThemeConfiguration();

  LocalThemeConfiguration.fromArgs({
    required this.themeMode,
    required this.mainColor,
  });

  LocalThemeConfiguration.fromEntity(ThemeConfiguration entity)
      : this.fromArgs(
          themeMode: entity.themeMode,
          mainColor: entity.mainColor,
        );

  int id = 0;
  String themeMode = '';
  String mainColor = '';

  @override
  ThemeConfiguration toEntity() {
    return ThemeConfiguration(
      themeMode: themeMode,
      mainColor: mainColor,
    );
  }
}
