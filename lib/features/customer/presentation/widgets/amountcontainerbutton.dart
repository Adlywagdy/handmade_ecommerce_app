import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class AmountContainerButton extends StatelessWidget {
  final double? fontSize;
  final Color? iconscolor;
  final Color? textcolor;
  final double circularradius;
  final double verticalpadding;
  final double horizontalpadding;
  final double? spacingwidth;
  const AmountContainerButton({
    super.key,
    this.fontSize = 16,
    this.iconscolor = commonColor,
    this.textcolor = blackDegree,
    this.circularradius = 12,
    this.verticalpadding = 12,
    this.horizontalpadding = 12,
    this.spacingwidth = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalpadding.h,
        horizontal: horizontalpadding.w,
      ),
      decoration: BoxDecoration(
        color: commonColor.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(circularradius.r),
        border: Border.all(
          color: commonColor.withValues(alpha: .1),
          width: 1.5,
        ),
      ),

      child: Row(
        spacing: spacingwidth!.w,
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
