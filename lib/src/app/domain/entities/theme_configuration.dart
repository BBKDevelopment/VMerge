// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:vmerge/src/core/core.dart';

final class ThemeConfiguration extends DomainEntity {
  const ThemeConfiguration({
    required this.themeMode,
    required this.mainColor,
  });

  final String themeMode;
  final String mainColor;

  @override
  List<Object?> get props => [themeMode, mainColor];
}
