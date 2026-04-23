import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/onboarding/presentation/screens/onboarding_screen.dart';

import '../../../../core/widgets/force_update_dialog.dart';
import '../../../../main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //if (RemoteConfigService.instance.isUpdateRequired) {
    //   ForceUpdateDialog.show(context);
    //   return;
    // }
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
        const OnboardingScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(seconds: 1),
      );
    });

    return Scaffold(
      backgroundColor: logobackgroundcolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 120, child: SizedBox()),
          Image.asset('assets/images/splash.jpeg'),
          Expanded(flex: 100, child: SizedBox()),
          Text(
            'Handmade with Love',
            style: AppTextStyles.t_16w600.copyWith(color: commonColor),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
