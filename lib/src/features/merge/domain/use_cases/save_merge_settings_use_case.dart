import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class SaveMergeSettingsUseCase
    implements UseCase<DataState<bool>, MergeSettings> {
  const SaveMergeSettingsUseCase({
    required MergeSettingsRepository repository,
  }) : _repository = repository;

  final MergeSettingsRepository _repository;

  @override
  Future<DataState<bool>> call({required MergeSettings params}) {
    return _repository.saveMergeSettings(params);
  }
}
