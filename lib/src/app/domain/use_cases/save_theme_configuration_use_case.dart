import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/core/core.dart';

final class SaveThemeConfigurationUseCase
    implements UseCase<DataState<void>, ThemeConfiguration> {
  SaveThemeConfigurationUseCase({
    required ThemeConfigurationRepository repository,
  }) : _repository = repository;

  final ThemeConfigurationRepository _repository;

  @override
  Future<DataState<void>> call({required ThemeConfiguration params}) {
    return _repository.saveThemeConfiguration(params);
  }
}
