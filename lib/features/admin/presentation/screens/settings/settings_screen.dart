import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';

import '../../../../../core/cubit/locale_cubit.dart';
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
          AppLocalizations.of(context)!.admSettings,
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
          label: AppLocalizations.of(context)!.admPlatformCommission,
          value: '${(settings.commissionRate * 100).toStringAsFixed(1)}%',
          onTap: () => showCommissionEditor(context, settings.commissionRate),
        ),
        SizedBox(height: 12.h),
        _SettingsTile(
          icon: Icons.local_shipping_outlined,
          label: AppLocalizations.of(context)!.admDeliveryFee,
          value:
              '${settings.currency} ${settings.deliveryFee.toStringAsFixed(0)}',
        ),
        SizedBox(height: 12.h),
        _SettingsTile(
          icon: Icons.shopping_bag_outlined,
          label: AppLocalizations.of(context)!.admMinimumOrderValue,
          value:
              '${settings.currency} ${settings.minOrderValue.toStringAsFixed(0)}',
        ),
        SizedBox(height: 12.h),
        _SettingsTile(
          icon: Icons.support_agent_outlined,
          label: AppLocalizations.of(context)!.admSupportEmail,
          value: settings.supportEmail.isNotEmpty ? settings.supportEmail : '—',
        ),
        SizedBox(height: 12.h),
        _LanguageTile(),
        SizedBox(height: 12.h),
        CustomElevatedButton(
          buttonheight: 60.h,
          onPressed: () async {
            await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.admLogoutTitle),
                  content: Text(
                      AppLocalizations.of(context)!.admLogoutConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(AppLocalizations.of(context)!.admCancel),
                    ),
                    TextButton(
                      onPressed: ()async{
                          await AuthService().signOut();
                          Get.offAllNamed(AppRoutes.login);
                      },
                      child: Text(AppLocalizations.of(context)!.admLogout,
                          style: TextStyle(color: redDegree)),
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
                AppLocalizations.of(context)!.admLogout,
                style: AppTextStyles.t_16w600.copyWith(color: redDegree),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocaleCubit>();
    // Arabic when the saved locale is 'ar'; otherwise English.
    final isArabic = context.watch<LocaleCubit>().state?.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
            child: Icon(Icons.language_outlined, color: commonColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.admLanguageRegion,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: blackDegree,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  isArabic ? 'العربية' : 'English (US)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: subTitleColor,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isArabic,
            activeThumbColor: commonColor,
            onChanged: (toArabic) =>
                toArabic ? cubit.switchToArabic() : cubit.switchToEnglish(),
          ),
        ],
      ),
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
