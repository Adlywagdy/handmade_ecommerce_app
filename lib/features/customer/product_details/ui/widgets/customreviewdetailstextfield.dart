import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomReviewDetailsTextField extends StatelessWidget {
  const CustomReviewDetailsTextField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Review Details', style: AppTextStyles.t_16w600),
            Card(
              elevation: 0,

              shape: BeveledRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(2.r),
              ),
              color: commonColor.withValues(alpha: .05),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                child: Text(
                  '${controller.text.length} / 500',
                  style: AppTextStyles.t_12w500.copyWith(color: subTitleColor),
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          cursorColor: commonColor,
          controller: controller,
          minLines: 1,
          maxLength: 500,
          maxLines: null,
          autocorrect: true,
          textAlignVertical: TextAlignVertical.top,
          onChanged: onChanged,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 80.h, top: 16.h),
            fillColor: Colors.white,
            filled: true,
            counterText: "",
            hint: Text(
              'Share your experience with the \ncraftsmanship, delivery, and overall \nquality...',

              style: AppTextStyles.t_16w400.copyWith(color: subTitleColor),
            ),
            focusedBorder: OutlineInputBorder(
              gapPadding: 16.w,
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: commonColor),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 16.w,
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: commonColor.withValues(alpha: .2)),
            ),
            border: OutlineInputBorder(
              gapPadding: 16.w,
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: commonColor.withValues(alpha: .2)),
            ),
          ),
        ),
      ],
    );
  }
}
