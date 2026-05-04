import 'package:flutter/widgets.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
