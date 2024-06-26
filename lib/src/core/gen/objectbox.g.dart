// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../../../src/app/data/models/local_theme_configuration.dart';
import '../../../src/features/merge/data/models/local_merge_settings.dart';
import '../../../src/features/merge/data/models/local_merge_statistics.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 8551260808493273318),
      name: 'LocalMergeSettings',
      lastPropertyId: const obx_int.IdUid(5, 4282369276157571834),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 3360665689172726783),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 5578878731541755337),
            name: 'isSoundOn',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 6608534077247407929),
            name: 'playbackSpeed',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 6444398988388069063),
            name: 'videoResolution',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 4282369276157571834),
            name: 'videoAspectRatio',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 4520518054235479906),
      name: 'LocalThemeConfiguration',
      lastPropertyId: const obx_int.IdUid(3, 7180929920422589669),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 3171587212615611172),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 470621667412049234),
            name: 'themeMode',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7180929920422589669),
            name: 'mainColor',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 6752277543447190155),
      name: 'LocalMergeStatistics',
      lastPropertyId: const obx_int.IdUid(5, 7060629709470016846),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5740094858668497488),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7986270554451540890),
            name: 'successMergeCount',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 7060629709470016846),
            name: 'failedMergeCount',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(3, 6752277543447190155),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [3379488580577270059, 4991885907385683044],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    LocalMergeSettings: obx_int.EntityDefinition<LocalMergeSettings>(
        model: _entities[0],
        toOneRelations: (LocalMergeSettings object) => [],
        toManyRelations: (LocalMergeSettings object) => {},
        getId: (LocalMergeSettings object) => object.id,
        setId: (LocalMergeSettings object, int id) {
          object.id = id;
        },
        objectToFB: (LocalMergeSettings object, fb.Builder fbb) {
          final playbackSpeedOffset = fbb.writeString(object.playbackSpeed);
          final videoResolutionOffset = fbb.writeString(object.videoResolution);
          final videoAspectRatioOffset =
              fbb.writeString(object.videoAspectRatio);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addBool(1, object.isSoundOn);
          fbb.addOffset(2, playbackSpeedOffset);
          fbb.addOffset(3, videoResolutionOffset);
          fbb.addOffset(4, videoAspectRatioOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = LocalMergeSettings()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..isSoundOn =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 6, false)
            ..playbackSpeed = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 8, '')
            ..videoResolution = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 10, '')
            ..videoAspectRatio = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 12, '');

          return object;
        }),
    LocalThemeConfiguration: obx_int.EntityDefinition<LocalThemeConfiguration>(
        model: _entities[1],
        toOneRelations: (LocalThemeConfiguration object) => [],
        toManyRelations: (LocalThemeConfiguration object) => {},
        getId: (LocalThemeConfiguration object) => object.id,
        setId: (LocalThemeConfiguration object, int id) {
          object.id = id;
        },
        objectToFB: (LocalThemeConfiguration object, fb.Builder fbb) {
          final themeModeOffset = fbb.writeString(object.themeMode);
          final mainColorOffset = fbb.writeString(object.mainColor);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, themeModeOffset);
          fbb.addOffset(2, mainColorOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = LocalThemeConfiguration()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..themeMode = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '')
            ..mainColor = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 8, '');

          return object;
        }),
    LocalMergeStatistics: obx_int.EntityDefinition<LocalMergeStatistics>(
        model: _entities[2],
        toOneRelations: (LocalMergeStatistics object) => [],
        toManyRelations: (LocalMergeStatistics object) => {},
        getId: (LocalMergeStatistics object) => object.id,
        setId: (LocalMergeStatistics object, int id) {
          object.id = id;
        },
        objectToFB: (LocalMergeStatistics object, fb.Builder fbb) {
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addInt64(3, object.successMergeCount);
          fbb.addInt64(4, object.failedMergeCount);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = LocalMergeStatistics()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..successMergeCount =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0)
            ..failedMergeCount =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [LocalMergeSettings] entity fields to define ObjectBox queries.
class LocalMergeSettings_ {
  /// see [LocalMergeSettings.id]
  static final id =
      obx.QueryIntegerProperty<LocalMergeSettings>(_entities[0].properties[0]);

  /// see [LocalMergeSettings.isSoundOn]
  static final isSoundOn =
      obx.QueryBooleanProperty<LocalMergeSettings>(_entities[0].properties[1]);

  /// see [LocalMergeSettings.playbackSpeed]
  static final playbackSpeed =
      obx.QueryStringProperty<LocalMergeSettings>(_entities[0].properties[2]);

  /// see [LocalMergeSettings.videoResolution]
  static final videoResolution =
      obx.QueryStringProperty<LocalMergeSettings>(_entities[0].properties[3]);

  /// see [LocalMergeSettings.videoAspectRatio]
  static final videoAspectRatio =
      obx.QueryStringProperty<LocalMergeSettings>(_entities[0].properties[4]);
}

/// [LocalThemeConfiguration] entity fields to define ObjectBox queries.
class LocalThemeConfiguration_ {
  /// see [LocalThemeConfiguration.id]
  static final id = obx.QueryIntegerProperty<LocalThemeConfiguration>(
      _entities[1].properties[0]);

  /// see [LocalThemeConfiguration.themeMode]
  static final themeMode = obx.QueryStringProperty<LocalThemeConfiguration>(
      _entities[1].properties[1]);

  /// see [LocalThemeConfiguration.mainColor]
  static final mainColor = obx.QueryStringProperty<LocalThemeConfiguration>(
      _entities[1].properties[2]);
}

/// [LocalMergeStatistics] entity fields to define ObjectBox queries.
class LocalMergeStatistics_ {
  /// see [LocalMergeStatistics.id]
  static final id = obx.QueryIntegerProperty<LocalMergeStatistics>(
      _entities[2].properties[0]);

  /// see [LocalMergeStatistics.successMergeCount]
  static final successMergeCount =
      obx.QueryIntegerProperty<LocalMergeStatistics>(
          _entities[2].properties[1]);

  /// see [LocalMergeStatistics.failedMergeCount]
  static final failedMergeCount =
      obx.QueryIntegerProperty<LocalMergeStatistics>(
          _entities[2].properties[2]);
}
