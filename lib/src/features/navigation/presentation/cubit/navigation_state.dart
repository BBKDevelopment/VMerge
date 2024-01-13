// Copyright 2023 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:equatable/equatable.dart';

final class NavigationState extends Equatable {
  const NavigationState({required this.page});

  final NavigationBarPage page;

  @override
  List<Object?> get props => [page];
}

enum NavigationBarPage {
  previewVideo,
  merge,
  more,
}
