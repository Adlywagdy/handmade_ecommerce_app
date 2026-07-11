import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/home/data/customer_model.dart';
<<<<<<< HEAD:lib/features/customer/profile/ui/widgets/user_profile_details.dart
import 'package:handmade_ecommerce_app/features/customer/profile/ui/widgets/custom_profile_picture.dart';
=======
import 'package:handmade_ecommerce_app/features/customer/profile/ui/widgets/customprofilepicture.dart';
import 'package:image_picker/image_picker.dart';
>>>>>>> main:lib/features/customer/profile/ui/widgets/userpofiledetails.dart

class UserProfileDetails extends StatelessWidget {
  const UserProfileDetails({
    super.key,
    required this.customer,
    this.onImagePicked,
  });

  final CustomerModel customer;
  final ValueChanged<XFile>? onImagePicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomProfilePicture(
          customer: customer,
          onImagePicked: onImagePicked,
        ),
        SizedBox(height: 16.h),
        Text(
          customer.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.t_24w700,
        ),
        Text(
          customer.email,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.t_16w500.copyWith(color: subTitleColor),
        ),
      ],
    );
  }
}
