// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/features/merge/merge.dart';

/// {@template object_box_merge_settings_service}
/// An implementation of [LocalMergeSettingsService] that uses
/// [ObjectBoxService] as the local service.
/// {@endtemplate}
final class ObjectBoxMergeSettingsService implements LocalMergeSettingsService {
  /// {@macro object_box_merge_settings_service}
  const ObjectBoxMergeSettingsService({required ObjectBoxService service})
      : _service = service;

  final ObjectBoxService _service;

  /// Gets the [LocalMergeSettings].
  @override
  Future<LocalMergeSettings> getMergeSettings() async {
    final box = _service.store.box<LocalMergeSettings>();
    final query = box.query().build();
    final entities = query.find();

    if (entities.isEmpty) {
      query.close();
      return saveMergeSettings(LocalMergeSettings());
    }

    final settings = entities.first;
    query.close();

    return settings;
  }

  /// Saves the [LocalMergeSettings].
  @override
  Future<LocalMergeSettings> saveMergeSettings(
    LocalMergeSettings settings,
  ) async {
    final box = _service.store.box<LocalMergeSettings>();
    final query = box.query().build();
    final entities = query.find();
    final oldSettings = entities.firstOrNull;
    query.close();

    if (oldSettings != null) settings.id = oldSettings.id;

    return box.putAndGetAsync(settings);
  }
}
