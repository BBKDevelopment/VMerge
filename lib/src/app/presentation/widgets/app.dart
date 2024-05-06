// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmerge/bootstrap.dart';
import 'package:vmerge/src/app/app.dart';
import 'package:vmerge/src/config/config.dart';
import 'package:vmerge/src/core/core.dart';
import 'package:vmerge/src/features/error/error.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (_) => AppCubit(
        getThemeConfigurationUseCase: getIt<GetThemeConfigurationUseCase>(),
        saveThemeConfigurationUseCase: getIt<SaveThemeConfigurationUseCase>(),
      )..init(),
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return switch (state) {
          AppInitializing() => const SizedBox.shrink(),
          AppInitialized() => MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: getIt<AppTheme>(
                param1: state.mainColor.value,
                instanceName: '$LightAppTheme',
              ).data,
              darkTheme: getIt<AppTheme>(
                param1: state.mainColor.value,
                instanceName: '$DarkAppTheme',
              ).data,
              themeMode: state.themeMode,
              home: const ErrorListener(
                child: AppNavigationBar(),
              ),
            ),
        };
      },
    );
  }
}
