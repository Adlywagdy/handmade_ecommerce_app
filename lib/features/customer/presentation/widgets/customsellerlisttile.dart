import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';

class CustomSellerListTile extends StatelessWidget {
  const CustomSellerListTile({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        product.seller.name,
        style: TextStyle(
          color: blackDegree,
          fontSize: 16.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, color: commonColor, size: 16.sp),
          Text(
            ' ${product.seller.badge} • ${product.seller.location}',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 12.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        radius: 28.r,
        backgroundColor: commonColor.withValues(alpha: 0.10),
        child: SvgPicture.asset('assets/images/unknown_user_icon.svg'),
      ),
      trailing: InkWell(
        onTap: () {
          // Handle view shop action
        },
        child: CustomTextContainer(
          verticalpadding: 8,
          horizontalpadding: 16,
          buttontext: 'View Shop',
          backGroundColor: commonColor.withValues(alpha: 0.10),
        ),
      ),
    );
  }
}
