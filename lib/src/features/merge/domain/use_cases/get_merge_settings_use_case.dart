import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class GetMergeSettingsUseCase
    implements UseCase<DataState<MergeSettings>, void> {
  const GetMergeSettingsUseCase({
    required MergeSettingsRepository mergeSettingsRepository,
  }) : _mergeSettingsRepository = mergeSettingsRepository;

  final MergeSettingsRepository _mergeSettingsRepository;

  @override
  Future<DataState<MergeSettings>> call({void params}) {
    return _mergeSettingsRepository.getMergeSettings();
  }
}
