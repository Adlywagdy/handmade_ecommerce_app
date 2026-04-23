import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';

class VerifyPasswordScreen extends StatelessWidget {
  const VerifyPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Icon(
              Icons.mark_email_read_outlined,
              size: 90.r,
              color: primaryColor,
            ),
            SizedBox(height: 20.h),
            Text(
              'Check your email',
              style: AppTextStyles.t_30w700.copyWith(color: primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              email.isNotEmpty
                  ? 'We sent a password reset link to\n$email\nPlease open your email and follow the instructions.'
                  : 'We sent a password reset link to your email.\nPlease open your email and follow the instructions.',
              style: AppTextStyles.t_12w500.copyWith(
                color: primaryColor.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Text(
              'If you don’t see the email, check your spam or junk folder.',
              style: AppTextStyles.t_12w500.copyWith(
                color: primaryColor.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: CustomElevatedButton(
          onPressed: () {
            Get.offAllNamed(AppRoutes.login);
          },
          buttoncolor: primaryColor,
          child: Text(
            'Back to Login',
            style: AppTextStyles.t_16w500.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}