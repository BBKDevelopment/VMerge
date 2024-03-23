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

import '../../../src/features/merge/data/models/local_merge_settings.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 8480514306824483187),
      name: 'LocalMergeSettings',
      lastPropertyId: const obx_int.IdUid(5, 5988162432875676751),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 4956396745360290319),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8428127085685007111),
            name: 'isSoundOn',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7808486242829979408),
            name: 'playbackSpeed',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7086592073638664485),
            name: 'videoResolution',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 5988162432875676751),
            name: 'videoAspectRatio',
            type: 9,
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
      lastEntityId: const obx_int.IdUid(2, 8480514306824483187),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [6340670761431747097],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        2521569766324816989,
        213874028732991268,
        5606106742822233060,
        6560843509079260207,
        8429516065717112211
      ],
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
