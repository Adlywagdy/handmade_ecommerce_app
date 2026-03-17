import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/onboarding/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
        const OnboardingScreen(),
        transition: Transition.fadeIn,
        duration: Duration(seconds: 1),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xffEEDFC8),
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Expanded(flex: 120, child: SizedBox()),
          Image.asset('assets/images/splash.jpeg'),
          Expanded(flex: 100, child: SizedBox()),
          Text(
            'Handmade with Love',
            style: TextStyle(
              color: commonColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
