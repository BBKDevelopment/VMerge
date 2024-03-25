// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:bloc/bloc.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';

final class AppNavigationBarCubit extends Cubit<AppNavigationBarState> {
  AppNavigationBarCubit()
      : super(
            const AppNavigationBarState(page: NavigationBarPage.previewVideo));

  void updatePage(NavigationBarPage page, {Object? arguments}) {
    emit(AppNavigationBarState(page: page, arguments: arguments));
  }
}
