// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/features/merge/merge.dart';

/// {@template local_merge_settings_service}
/// An interface that inherits from [MergeSettingsService] and defines the
/// requirements for implementations that use a local service.
///
/// The [LocalMergeSettings] type is the model type.
/// {@endtemplate}
abstract interface class LocalMergeSettingsService
    implements MergeSettingsService<LocalMergeSettings> {
  /// {@macro local_merge_settings_service}
  const LocalMergeSettingsService();
}
