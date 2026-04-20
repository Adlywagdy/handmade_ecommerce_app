import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';

class BecomeSellerCard extends StatelessWidget {
  const BecomeSellerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: orangedegree,
      child: ListTile(
        contentPadding: const EdgeInsets.all(20).h,
        title: Text(
          'Become a Seller',
          style: AppTextStyles.t_18w700.copyWith(color: Colors.white),
        ),
        subtitle: Text(
          'Start selling your handcrafted products today.',
          style: AppTextStyles.t_14w400.copyWith(color: Colors.white),
        ),
        trailing: CustomIconButton(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          icon: Icons.arrow_forward,
          iconcolor: Colors.white,
        ),
      ),
    );
  }
}
