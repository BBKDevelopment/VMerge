// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vmerge/src/core/core.dart';

/// An extension that provides additional functionality to the [AppMainColor]
/// enum.
extension AppMainColorExt on AppMainColor {
  /// Returns the name of the color based on the enum value.
  String name(BuildContext context) {
    return switch (this) {
      AppMainColor.red => context.l10n.red,
      AppMainColor.pink => context.l10n.pink,
      AppMainColor.purple => context.l10n.purple,
      AppMainColor.indigo => context.l10n.indigo,
      AppMainColor.blue => context.l10n.blue,
      AppMainColor.cyan => context.l10n.cyan,
      AppMainColor.teal => context.l10n.teal,
      AppMainColor.green => context.l10n.green,
      AppMainColor.lime => context.l10n.lime,
      AppMainColor.yellow => context.l10n.yellow,
      AppMainColor.orange => context.l10n.orange,
      AppMainColor.brown => context.l10n.brown,
    };
  }
}
