// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';

final class AppNavigationBarState extends Equatable {
  const AppNavigationBarState({required this.page, this.arguments});

  final NavigationBarPage page;
  final Object? arguments;

  @override
  List<Object?> get props => [page];
}

enum NavigationBarPage {
  previewVideo,
  merge,
  more,
}
