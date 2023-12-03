// Copyright 2022 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:launch_review_service/launch_review_service.dart';
import 'package:url_launcher_service/url_launcher_service.dart';
import 'package:vmerge/utilities/utilities.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  await Future.wait(
    [
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      PhotoManager.clearFileCache(),
      setup(),
    ],
  ).onError((error, stackTrace) => [log('$error', stackTrace: stackTrace)]);

  runApp(await builder());
}

Future<void> setup() async {
  getIt
    ..registerLazySingleton<LaunchReviewService>(
      () => const LaunchReviewService(androidAppId: kAndroidAppId),
    )
    ..registerLazySingleton<UrlLauncherService>(
      () => const UrlLauncherService(),
    );
}
