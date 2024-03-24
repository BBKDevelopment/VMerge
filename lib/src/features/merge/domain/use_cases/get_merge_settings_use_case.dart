import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class GetMergeSettingsUseCase
    implements UseCase<DataState<MergeSettings>, void> {
  const GetMergeSettingsUseCase({
    required MergeSettingsRepository repository,
  }) : _repository = repository;

  final MergeSettingsRepository _repository;

  @override
  Future<DataState<MergeSettings>> call({void params}) {
    return _repository.getMergeSettings();
  }
}
