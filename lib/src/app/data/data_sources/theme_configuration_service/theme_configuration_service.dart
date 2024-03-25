export 'local_theme_configuration_service.dart';
export 'object_box_theme_configuration_service.dart';

abstract interface class ThemeConfigurationService<M> {
  const ThemeConfigurationService();

  Future<M> getThemeConfiguration();

  Future<void> saveThemeConfiguration(M configuration);
}
