import 'package:flutter/material.dart';
import 'package:vmerge/src/core/core.dart';

extension AppColorExt on AppColor {
  String name(BuildContext context) {
    return switch (this) {
      AppColor.red => context.l10n.red,
      AppColor.pink => context.l10n.pink,
      AppColor.purple => context.l10n.purple,
      AppColor.indigo => context.l10n.indigo,
      AppColor.blue => context.l10n.blue,
      AppColor.cyan => context.l10n.cyan,
      AppColor.teal => context.l10n.teal,
      AppColor.green => context.l10n.green,
      AppColor.lime => context.l10n.lime,
      AppColor.yellow => context.l10n.yellow,
      AppColor.orange => context.l10n.orange,
      AppColor.brown => context.l10n.brown,
    };
  }
}
