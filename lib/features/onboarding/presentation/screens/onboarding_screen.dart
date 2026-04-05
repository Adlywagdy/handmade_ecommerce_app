import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/onboarding/models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.login);
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: subtitlesplash,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20).r,
        child: Column(
          children: [
            SizedBox(height: 150.h),
            Image.asset(
              'assets/icons/onboarding/icon_$count.png',
              height: 130.h,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: 305.w,
              child: Text(
                textAlign: TextAlign.center,
                OnboardingTitleDescription.titles[count - 1],
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: 312.w,
              child: Text(
                textAlign: TextAlign.center,
                OnboardingTitleDescription.subTitle[count - 1],
                style: TextStyle(fontSize: 16.sp, color: subtitlesplash),
              ),
            ),
            Spacer(),
            SizedBox(
              width: 80.w,
              child: Image.asset(
                'assets/icons/onboarding/onboarding_icon_$count.png',
              ),
            ),
            SizedBox(height: 10.h),
            CustomElevatedButton(
              buttoncolor: commonColor,
              onPressed: () {
                if (count < 3) count++;
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    count < 3 ? 'Next' : 'Get Started',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  if (count < 3) Icon(Icons.navigate_next, color: Colors.white),
                ],
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
