import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/customelevatedbutton.dart';
import '../../../../auth/services/auth_service.dart';
import '../../../cubit/admin_cubit.dart';
import '../../../models/settings_model.dart';
import '../../widgets/commission_editor_dialog.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: blackDegree,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          final settings = context.read<AdminCubit>().settings;
          return _SettingsBody(settings: settings);
        },
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  final SettingsModel settings;

  const _SettingsBody({required this.settings});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _SettingsTile(
          icon: Icons.percent,
          label: 'Platform Commission',
          value: '${(settings.commissionRate * 100).toStringAsFixed(1)}%',
          onTap: () => showCommissionEditor(context, settings.commissionRate),
        ),
        SizedBox(height: 12.h),
        _SettingsTile(
          icon: Icons.local_shipping_outlined,
          label: 'Delivery Fee',
          value:
              '${settings.currency} ${settings.deliveryFee.toStringAsFixed(0)}',
        ),
        SizedBox(height: 12.h),
        _SettingsTile(
          icon: Icons.shopping_bag_outlined,
          label: 'Minimum Order Value',
          value:
              '${settings.currency} ${settings.minOrderValue.toStringAsFixed(0)}',
        ),
        SizedBox(height: 12.h),
        _SettingsTile(
          icon: Icons.support_agent_outlined,
          label: 'Support Email',
          value: settings.supportEmail.isNotEmpty ? settings.supportEmail : '—',
        ),
        SizedBox(height: 12.h),
        CustomElevatedButton(
          buttonheight: 60.h,
          onPressed: () async {
            await showDialog<bool>(
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
                      onPressed: ()async{
                          await AuthService().signOut();
                          Get.offAllNamed(AppRoutes.login);
                      },
                      child: Text('Logout', style: TextStyle(color: redDegree)),
                    ),
                  ],
                );
              },
            );
          },
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
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: commonColor.withValues(alpha: 0.10)),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: commonColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: commonColor, size: 20.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: subTitleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: blackDegree,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.edit_outlined, color: commonColor, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
