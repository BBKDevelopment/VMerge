// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

export 'local_merge_settings_service.dart';
export 'object_box_merge_settings_service.dart';

/// {@template merge_settings_service}
/// An interface that defines the requirements for implementations.
///
/// The [M] type is the model type.
/// {@endtemplate}
abstract interface class MergeSettingsService<M> {
  /// {@macro merge_settings_service}
  const MergeSettingsService();

  Future<M> getMergeSettings();

  Future<void> saveMergeSettings(M settings);
}
