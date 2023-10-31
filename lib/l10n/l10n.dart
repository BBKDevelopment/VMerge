import 'package:flutter/widgets.dart';
import 'package:vmerge/l10n/l10n.dart';

export 'package:vmerge/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
