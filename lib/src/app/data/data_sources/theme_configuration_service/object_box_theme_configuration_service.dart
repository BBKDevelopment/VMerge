import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/app/app.dart';

final class ObjectBoxThemeConfigurationService
    implements LocalThemeConfigurationService {
  ObjectBoxThemeConfigurationService({
    required ObjectBoxService service,
  }) : _service = service;

  final ObjectBoxService _service;

  @override
  Future<LocalThemeConfiguration> getThemeConfiguration() async {
    final box = _service.store.box<LocalThemeConfiguration>();
    final query = box.query().build();
    final entities = query.find();
    final configuration = entities.first;
    query.close();

    return configuration;
  }

  @override
  Future<void> saveThemeConfiguration(
    LocalThemeConfiguration configuration,
  ) async {
    final box = _service.store.box<LocalThemeConfiguration>();
    final query = box.query().build();
    final entities = query.find();
    final oldConfiguration = entities.firstOrNull;
    query.close();

    if (oldConfiguration != null) configuration.id = oldConfiguration.id;

    box.put(configuration);
  }
}
