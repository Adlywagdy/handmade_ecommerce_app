import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';

class CustomProfilePicture extends StatelessWidget {
  const CustomProfilePicture({super.key, required this.customer});
  final CustomerModel customer;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 81.r,
          backgroundColor: commonColor.withValues(alpha: .15),
          child: CircleAvatar(
            radius: 80.r,
            backgroundColor: Colors.white.withValues(alpha: .5),
            child: CircleAvatar(
              radius: 75.r,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(customer.image!),
            ),
          ),
        ),
        Positioned(
          bottom: 0.h,
          right: 0.h,
          child: CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.white,
            child: CustomIconButton(
              backgroundColor: commonColor,
              icon: Icons.camera_alt_outlined,
              iconcolor: Colors.white,
              iconsize: 22.r,
            ),
          ),
        ),
      ],
    );
  }
}
