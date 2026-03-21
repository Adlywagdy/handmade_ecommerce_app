import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class AmountContainerButton extends StatelessWidget {
  final double? fontSize;
  final Color? iconscolor;
  final Color? textcolor;
  const AmountContainerButton({
    super.key,
    this.fontSize = 16,
    this.iconscolor = commonColor,
    this.textcolor = blackDegree,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: commonColor.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: commonColor.withValues(alpha: .1),
          width: 1.5,
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Icon(Icons.remove, color: iconscolor),
          ),
          Text(
            '1', // This should be a variable that holds the current amount selected by the user
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textcolor,
              fontSize: fontSize!.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Icon(Icons.add, color: iconscolor),
          ),
        ],
      ),
    );
  }
}
