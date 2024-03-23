import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class SaveMergeSettingsUseCase
    implements UseCase<DataState<bool>, MergeSettings> {
  const SaveMergeSettingsUseCase({
    required MergeSettingsRepository mergeSettingsRepository,
  }) : _mergeSettingsRepository = mergeSettingsRepository;

  final MergeSettingsRepository _mergeSettingsRepository;

  @override
  Future<DataState<bool>> call({required MergeSettings params}) {
    return _mergeSettingsRepository.saveMergeSettings(params);
  }
}
