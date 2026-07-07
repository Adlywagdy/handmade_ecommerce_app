import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/change_language_dropdown_widget.dart';
import 'package:handmade_ecommerce_app/core/widgets/custom_elevated_button.dart';
import 'package:handmade_ecommerce_app/features/onboarding/models/onboarding_model.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  int count = 1;

  void _finishOnboarding() {
    HiveHelper.setOnboardingBox();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        titleSpacing: 20.w,

        title: Row(
          children: [
            const ChangeLanguageWidget(),

            const Spacer(),

            TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                context.l10n.skip,
                style: AppTextStyles.t_16w500.copyWith(
                  color: subtitlesplash,
                ),
              ),
            ),
          ],
        ),
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
                OnboardingTitleDescription
                    .titles(context)[count - 1],
                textAlign: TextAlign.center,
                style: AppTextStyles.t_24w500.copyWith(
                  color: subtitlesplash,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            SizedBox(
              width: 312.w,
              child: Text(
                OnboardingTitleDescription
                    .subTitle(context)[count - 1],
                textAlign: TextAlign.center,
                style: AppTextStyles.t_16w500.copyWith(
                  color: subtitlesplash,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: 80.w,
              child: Image.asset(
                'assets/icons/onboarding/'
                'onboarding_icon_$count.png',
              ),
            ),

            SizedBox(height: 10.h),

            CustomElevatedButton(
              buttoncolor: commonColor,

              onPressed: () {
                if (count < 3) {
                  setState(() {
                    count++;
                  });
                } else {
                  _finishOnboarding();
                }
              },

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    count < 3
                        ? context.l10n.next
                        : context.l10n.getStarted,
                    style:
                        AppTextStyles.t_16w600.copyWith(
                      color: Colors.white,
                    ),
                  ),

                  if (count < 3) ...[
                    SizedBox(width: 4.w),

                    const Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    ),
                  ],
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