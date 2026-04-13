import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
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
        style: AppTextStyles.t_16w600.copyWith(color: blackDegree),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, color: commonColor, size: 16.r),
          Text(
            ' ${product.seller.badge} • ${product.seller.location}',
            style: AppTextStyles.t_12w500.copyWith(color: subTitleColor),
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
          text: 'View Shop',
          textstyle: AppTextStyles.t_14w700.copyWith(color: commonColor),
          backGroundColor: commonColor.withValues(alpha: 0.10),
        ),
      ),
    );
  }
}
