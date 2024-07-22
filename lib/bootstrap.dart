// Copyright 2022 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ffmpeg_service/ffmpeg_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_review_service/in_app_review_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher_service/url_launcher_service.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_service/video_player_service.dart';
import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/config/config.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/merge/merge.dart';
import 'package:wakelock_service/wakelock_service.dart';

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
  final packageInfo = await PackageInfo.fromPlatform();

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
    ..registerLazySingleton<LocalThemeConfigurationService>(
      () => ObjectBoxThemeConfigurationService(
        service: getIt<ObjectBoxService>(),
      ),
    )
    ..registerLazySingleton<ThemeConfigurationRepository>(
      () => ThemeConfigurationRepositoryImpl(
        localService: getIt<LocalThemeConfigurationService>(),
      ),
    )
    ..registerLazySingleton(
      () => GetThemeConfigurationUseCase(
        repository: getIt<ThemeConfigurationRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => SaveThemeConfigurationUseCase(
        repository: getIt<ThemeConfigurationRepository>(),
      ),
    )
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
    ..registerLazySingleton<LocalMergeStatisticsService>(
      () => ObjectBoxMergeStatisticsService(
        service: getIt<ObjectBoxService>(),
      ),
    )
    ..registerLazySingleton<MergeStatisticsRepository>(
      () => MergeStatisticsRepositoryImpl(
        localService: getIt<LocalMergeStatisticsService>(),
      ),
    )
    ..registerLazySingleton<GetMergeStatisticsUseCase>(
      () => GetMergeStatisticsUseCase(
        repository: getIt<MergeStatisticsRepository>(),
      ),
    )
    ..registerLazySingleton<SaveMergeStatisticsUseCase>(
      () => SaveMergeStatisticsUseCase(
        repository: getIt<MergeStatisticsRepository>(),
      ),
    )
    ..registerLazySingleton<PackageInfo>(
      () => packageInfo,
    )
    ..registerLazySingleton<InAppReviewService>(
      InAppReviewService.new,
    )
    ..registerLazySingleton<UrlLauncherService>(
      () => const UrlLauncherService(),
    )
    ..registerLazySingleton<FFmpegService>(
      FFmpegService.new,
    )
    ..registerLazySingleton<WakelockService>(
      () => const WakelockService(),
    )
    ..registerFactory<VideoPlayerService>(
      () => VideoPlayerService(options: VideoPlayerOptions()),
    );
}

final class ObjectBoxService {
  ObjectBoxService._create(this.store);

  /// The Store of this app.
  final Store store;

  /// Creates an instance of ObjectBoxService to use throughout the app.
  static Future<ObjectBoxService> create() async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: join(appDocsDir.path, 'vmerge_db'));
    return ObjectBoxService._create(store);
  }
}
