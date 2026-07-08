import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/customer/shop_details/data/customer_seller_profile_service.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

final _sellerService = CustomerSellerProfileService();

class CustomSellerListTile extends StatelessWidget {
  const CustomSellerListTile({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final sellerIdentifier = product.sellerId;

    return FutureBuilder<SellerModel>(
      future: _sellerService.getSellerProfile(sellerIdentifier),
      builder: (context, snapshot) {
        final seller = snapshot.data ?? product.seller;
        final sellerName = seller.displayName;
        final sellerBadge = seller.displayBadge;
        final sellerLocation = seller.displayLocation;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            sellerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.t_16w600.copyWith(color: blackDegree),
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_outlined, color: commonColor, size: 16.r),
              Expanded(
                child: Text(
                  ' $sellerBadge • $sellerLocation',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.t_12w500.copyWith(color: subTitleColor),
                ),
              ),
            ],
          ),
          leading: CircleAvatar(
            radius: 28.r,
            backgroundColor: commonColor.withValues(alpha: 0.10),
            child: SvgPicture.asset('assets/images/unknown_user_icon.svg'),
          ),
          trailing: GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.customerShopDetails,
                arguments: sellerIdentifier,
              );
            },
            child: CustomTextContainer(
              verticalpadding: 8,
              horizontalpadding: 16,
              text: context.l10n.viewShop,
              textstyle: AppTextStyles.t_14w700.copyWith(color: commonColor),
              backGroundColor: commonColor.withValues(alpha: 0.10),
            ),
          ),
        );
      },
    );
  }
}
