import 'package:flutter/widgets.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

abstract class OnboardingTitleDescription {
  static List<String> titles(BuildContext context) => [
    context.l10n.discoverUniqueHandmadeItems,
    context.l10n.supportLocalArtisans,
    context.l10n.shopWithConfidence,
  ];

  static List<String> subTitle(BuildContext context) => [
    context.l10n.exploreThousandsHandcraftedProducts,
    context.l10n.connectDirectlyWithMakers,
    context.l10n.securePaymentsVerifiedSellers,
  ];
}
