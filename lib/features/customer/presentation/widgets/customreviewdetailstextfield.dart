import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomReviewDetailsTextField extends StatefulWidget {
  const CustomReviewDetailsTextField({super.key});

  @override
  State<CustomReviewDetailsTextField> createState() =>
      _CustomReviewDetailsTextFieldState();
}

TextEditingController? textfieldcontroller;

class _CustomReviewDetailsTextFieldState
    extends State<CustomReviewDetailsTextField> {
  @override
  void initState() {
    textfieldcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textfieldcontroller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Review Details',
              style: TextStyle(
                color: blackDegree,
                fontSize: 16.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            Card(
              elevation: 0,

              shape: BeveledRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(2.r),
              ),
              color: commonColor.withValues(alpha: .05),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                child: Text(
                  '${textfieldcontroller?.text.length ?? 0} / 500',
                  style: TextStyle(
                    color: subTitleColor,
                    fontSize: 12.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                  ),
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          cursorColor: commonColor,
          controller: textfieldcontroller,
          minLines: 1,
          maxLength: 500,
          maxLines: null,
          autocorrect: true,
          textAlignVertical: TextAlignVertical.top,
          onChanged: (value) {
            setState(() {});
          },
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

              style: TextStyle(
                color: subTitleColor,
                fontSize: 16.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.63,
              ),
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
