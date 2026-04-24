import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';

Future<String> getInitialRoute() async {
  final seenOnboarding = HiveHelper.getOnboardingBox();
  final isLoggedIn = HiveHelper.getLoginBox();

  if (!seenOnboarding) {
    return AppRoutes.onboarding;
  }

  if (!isLoggedIn) {
    return AppRoutes.login;
  }

  return AppRoutes.decider;
}