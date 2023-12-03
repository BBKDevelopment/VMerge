// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:bloc/bloc.dart';
import 'package:vmerge/src/features/navigation/navigation.dart';

final class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit(super.initialState);

  void updatePage(NavigationBarPage page) {
    emit(NavigationState(page: page));
  }
}
