// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';

final class AppNavigationBarState extends Equatable {
  const AppNavigationBarState({
    required this.page,
    this.args,
    this.isSafeToNavigate = true,
  });

  final NavigationBarPage page;
  final Object? args;
  final bool isSafeToNavigate;

  @override
  String toString() {
    return 'AppNavigationBarState(page: $page, args: $args, isSafeToNavigate: '
        '$isSafeToNavigate)';
  }

  @override
  List<Object?> get props => [page, args, isSafeToNavigate];
}

enum NavigationBarPage {
  previewVideo,
  merge,
  more,
}
