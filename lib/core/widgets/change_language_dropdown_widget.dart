import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/cubit/locale_cubit.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale?>(
      builder: (context, locale) {
        final currentLocale = locale ?? Localizations.localeOf(context);

        final isArabic = currentLocale.languageCode == 'ar';

        return Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            color: Colors.white.withValues(alpha: 0.75),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: commonColor.withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: -2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.globe, color: commonColor, size: 18.sp),

              SizedBox(width: 4.w),

              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: isArabic ? 'ar' : 'en',

                  isDense: true,

                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: commonColor,
                    size: 20.sp,
                  ),

                  items: [
                    DropdownMenuItem<String>(
                      value: 'en',
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    DropdownMenuItem<String>(
                      value: 'ar',
                      child: Text(
                        'العربية',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  onChanged: (value) {
                    if (value == null) return;

                    final localeCubit = context.read<LocaleCubit>();

                    if (value == 'ar') {
                      localeCubit.switchToArabic();
                    } else {
                      localeCubit.switchToEnglish();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
