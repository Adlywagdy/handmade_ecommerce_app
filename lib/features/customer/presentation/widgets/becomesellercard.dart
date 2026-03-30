import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.56,
          ),
        ),
        subtitle: Text(
          'Start selling your handcrafted\nproducts today.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.80),
            fontSize: 14.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.38,
          ),
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
