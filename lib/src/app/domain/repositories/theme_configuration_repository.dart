import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/core/core.dart';

abstract interface class ThemeConfigurationRepository {
  const ThemeConfigurationRepository();

  Future<DataState<ThemeConfiguration>> getThemeConfiguration();

  Future<DataState<void>> saveThemeConfiguration(
    ThemeConfiguration configuration,
  );
}
