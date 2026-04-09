import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';

class CustomerDetailsItem extends StatelessWidget {
  final Map<String, dynamic>? item;
  const CustomerDetailsItem({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,

      child: ListTile(
        leading: Card(
          color: commonColor.withValues(alpha: .1),
          elevation: 0,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 12.h,
              right: 12,
              left: 12,
              top: 12.h,
            ),
            child: Icon(item!['icon'], color: commonColor, size: 26.r),
          ),
        ),
        title: Text(item!['title'], style: AppTextStyles.t_16w600),
        subtitle: Text(
          item!['subtitle'],
          style: AppTextStyles.t_12w400.copyWith(color: subTitleColor),
        ),
        trailing: CustomIconButton(
          backgroundColor: Colors.white,
          icon: Icons.arrow_forward_ios_outlined,
          iconsize: 20.r,
          iconcolor: subTitleColor.withValues(alpha: .6),
        ),
      ),
    );
  }
}
