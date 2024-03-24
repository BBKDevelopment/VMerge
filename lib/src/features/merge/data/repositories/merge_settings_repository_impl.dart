import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class MergeSettingsRepositoryImpl implements MergeSettingsRepository {
  const MergeSettingsRepositoryImpl({
    required LocalMergeSettingsService localService,
  }) : _localService = localService;

  final LocalMergeSettingsService _localService;

  @override
  Future<DataState<MergeSettings>> getMergeSettings() async {
    try {
      final localMergeSettings = await _localService.getMergeSettings();
      final mergeSettings = localMergeSettings.toEntity();
      return DataSuccess(mergeSettings);
    } catch (error, stackTrace) {
      return DataFailure(
        Failure(
          'Could not get merge settings!',
          error: error,
          name: '$MergeSettingsRepositoryImpl',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DataState<bool>> saveMergeSettings(MergeSettings settings) async {
    try {
      final localMergeSettings = LocalMergeSettings.fromEntity(settings);
      await _localService.saveMergeSettings(localMergeSettings);
      return const DataSuccess(true);
    } catch (error, stackTrace) {
      return DataFailure(
        Failure(
          'Could not save merge settings!',
          error: error,
          name: '$MergeSettingsRepositoryImpl',
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
