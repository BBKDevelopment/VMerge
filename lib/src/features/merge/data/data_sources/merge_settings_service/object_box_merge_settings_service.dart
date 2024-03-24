import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/features/merge/merge.dart';

/// {@template object_box_merge_settings_service}
/// An implementation of [LocalMergeSettingsService] that uses
/// [ObjectBoxService] as the local service.
/// {@endtemplate}
final class ObjectBoxMergeSettingsService implements LocalMergeSettingsService {
  /// {@macro object_box_merge_settings_service}
  const ObjectBoxMergeSettingsService({required ObjectBoxService service})
      : _service = service;

  final ObjectBoxService _service;

  /// Gets the [LocalMergeSettings].
  @override
  Future<LocalMergeSettings> getMergeSettings() async {
    final box = _service.store.box<LocalMergeSettings>();
    final query = box.query().build();
    final entities = query.find();
    final settings = entities.first;
    query.close();

    return settings;
  }

  /// Saves the [LocalMergeSettings].
  @override
  Future<void> saveMergeSettings(LocalMergeSettings settings) async {
    final box = _service.store.box<LocalMergeSettings>();
    final query = box.query().build();
    final entities = query.find();
    final oldSettings = entities.firstOrNull;
    query.close();

    if (oldSettings != null) settings.id = oldSettings.id;

    box.put(settings);
  }
}
