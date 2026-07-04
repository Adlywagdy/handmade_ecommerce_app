import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/presentation/widgets/customprofilepicture.dart';

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
          style: AppTextStyles.t_24w700,
        ),
        Text(
          customer.email,
          textAlign: TextAlign.center,
          style: AppTextStyles.t_16w500.copyWith(color: subTitleColor),
        ),
      ],
    );
  }
}
