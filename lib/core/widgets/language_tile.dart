import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/cubit/locale_cubit.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({super.key});

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