// Copyright 2022 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:launch_review_service/launch_review_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher_service/url_launcher_service.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/src/config/config.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:vmerge/utilities/utilities.dart';

final getIt = GetIt.instance;

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  LicenseRegistry.addLicense(() async* {
    final robotoMono = await rootBundle.loadString(Assets.licenses.robotoMono);
    final materialDesignIcons =
        await rootBundle.loadString(Assets.licenses.materialDesignIcons);
    final materialIcons =
        await rootBundle.loadString(Assets.licenses.materialIcons);

    yield LicenseEntryWithLineBreaks(['roboto-mono'], robotoMono);
    yield LicenseEntryWithLineBreaks(
      ['material-design-icons'],
      materialDesignIcons,
    );
    yield LicenseEntryWithLineBreaks(['material-icons'], materialIcons);
  });

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  await Future.wait(
    [
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      setup(),
    ],
  ).onError((error, stackTrace) => [log('$error', stackTrace: stackTrace)]);

  runApp(await builder());
}

Future<void> setup() async {
  final objectBoxService = await ObjectBoxService.create();

  getIt
    ..registerFactoryParam<AppTheme, Color, void>(
      (color, _) => LightAppTheme(color),
      instanceName: '$LightAppTheme',
    )
    ..registerFactoryParam<AppTheme, Color, void>(
      (color, _) => DarkAppTheme(color),
      instanceName: '$DarkAppTheme',
    )
    ..registerLazySingleton<ObjectBoxService>(() => objectBoxService)
    ..registerLazySingleton<LocalMergeSettingsService>(
      () => ObjectBoxMergeSettingsService(
        service: getIt<ObjectBoxService>(),
      ),
    )
    ..registerLazySingleton<MergeSettingsRepository>(
      () => MergeSettingsRepositoryImpl(
        localService: getIt<LocalMergeSettingsService>(),
      ),
    )
    ..registerLazySingleton<GetMergeSettingsUseCase>(
      () => GetMergeSettingsUseCase(
        repository: getIt<MergeSettingsRepository>(),
      ),
    )
    ..registerLazySingleton<SaveMergeSettingsUseCase>(
      () => SaveMergeSettingsUseCase(
        repository: getIt<MergeSettingsRepository>(),
      ),
    )
    ..registerLazySingleton<LaunchReviewService>(
      () => const LaunchReviewService(androidAppId: kAndroidAppId),
    )
    ..registerLazySingleton<UrlLauncherService>(
      () => const UrlLauncherService(),
    )
    ..registerFactory<VideoPlayerService>(
      () => VideoPlayerService(options: VideoPlayerOptions()),
    );
}

final class ObjectBoxService {
  ObjectBoxService._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// The Store of this app.
  final Store store;

  /// Create an instance of ObjectBoxService to use throughout the app.
  static Future<ObjectBoxService> create() async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: join(appDocsDir.path, "obx-example"));
    return ObjectBoxService._create(store);
  }
}
