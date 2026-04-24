import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';

import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout', style: TextStyle(color: redDegree)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await AuthService().signOut();
      await HiveHelperService.setLoginBox(value: false);
      await HiveHelperService.clearEmailBox();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: AppBar(
        backgroundColor: customerbackGroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: Text('Profile', style: AppTextStyles.t_18w700),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            Container(
              width: 104.w,
              height: 104.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: commonColor.withValues(alpha: 0.10),
                border: Border.all(
                  color: commonColor.withValues(alpha: 0.18),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: user?.photoURL != null && user!.photoURL!.isNotEmpty
                    ? Image.network(
                        user.photoURL!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.storefront_rounded,
                          size: 48.w,
                          color: commonColor,
                        ),
                      )
                    : Icon(
                        Icons.storefront_rounded,
                        size: 48.w,
                        color: commonColor,
                      ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(user?.displayName ?? 'Seller', style: AppTextStyles.t_20w700),
            SizedBox(height: 4.h),
            if (user?.email != null)
              Text(
                user!.email!,
                style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
              ),
            SizedBox(height: 28.h),
            _ProfileMenuTile(
              icon: Icons.storefront_outlined,
              title: 'Shop Settings',
              subtitle: 'View your shop information',
              onTap: () {},
            ),
            _ProfileMenuTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Open your notifications center',
              onTap: () => Get.toNamed(AppRoutes.notifications),
            ),
            _ProfileMenuTile(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle: 'Contact support and review help info',
              onTap: () {},
            ),
            SizedBox(height: 24.h),
            CustomElevatedButton(
              buttonheight: 60.h,
              onPressed: () => _confirmLogout(context),
              bordercolor: redDegree.withValues(alpha: 0.10),
              buttoncolor: redDegree.withValues(alpha: 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: redDegree, size: 22.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Logout',
                    style: AppTextStyles.t_16w600.copyWith(color: redDegree),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: commonColor.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: commonColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: commonColor, size: 22.w),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.t_16w600),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.t_12w500.copyWith(
                        color: subTitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: greyTextColor,
                size: 22.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
