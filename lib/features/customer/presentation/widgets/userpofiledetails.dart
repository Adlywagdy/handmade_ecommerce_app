import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customprofilepicture.dart';

class UserProfileDetails extends StatelessWidget {
  const UserProfileDetails({super.key, required this.customer});

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomProfilePicture(customer: customer),
        SizedBox(height: 16.h),
        Text(
          customer.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blackDegree,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.33,
            letterSpacing: -0.60,
          ),
        ),
        Text(
          customer.email!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: subTitleColor,
            fontSize: 16.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
      ],
    );
  }
}
