import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';

abstract interface class MergeSettingsRepository {
  const MergeSettingsRepository();

  Future<DataState<MergeSettings>> getMergeSettings();

  Future<DataState<bool>> saveMergeSettings(MergeSettings settings);
}
