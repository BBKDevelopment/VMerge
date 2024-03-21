export 'local_settings_service.dart';
export 'object_box_settings_service.dart';

abstract interface class SettingsService<T> {
  const SettingsService();

  Future<T> getMergeSettings();
}
