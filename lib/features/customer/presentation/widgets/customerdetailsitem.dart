import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            padding: const EdgeInsets.all(8.0).h,
            child: Icon(item!['icon'], color: commonColor, size: 26.r),
          ),
        ),
        title: Text(
          item!['title'],
          style: TextStyle(
            color: blackDegree,
            fontSize: 16.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        subtitle: Text(
          item!['subtitle'],
          style: TextStyle(
            color: subTitleColor,
            fontSize: 12.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.33,
          ),
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
