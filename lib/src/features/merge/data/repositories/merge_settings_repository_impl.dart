import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

final class MergeSettingsRepositoryImpl implements MergeSettingsRepository {
  const MergeSettingsRepositoryImpl({
    required LocalMergeSettingsService localMergeSettingsService,
  }) : _localMergeSettingsService = localMergeSettingsService;

  final LocalMergeSettingsService _localMergeSettingsService;

  @override
  Future<DataState<MergeSettings>> getMergeSettings() async {
    try {
      final localMergeSettings =
          await _localMergeSettingsService.getMergeSettings();
      final mergeSettings = localMergeSettings.toEntity();
      return DataSuccess(mergeSettings);
    } catch (exception, stackTrace) {
      return DataFailure(
        Failure(
          exception: exception,
          message: 'Could not get merge settings!',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DataState<bool>> saveMergeSettings(MergeSettings settings) async {
    try {
      final localMergeSettings = LocalMergeSettings.fromEntity(settings);
      await _localMergeSettingsService.saveMergeSettings(localMergeSettings);
      return const DataSuccess(true);
    } catch (exception, stackTrace) {
      return DataFailure(
        Failure(
          exception: exception,
          message: 'Could not save merge settings!',
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
