import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_shop_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/services/customer_seller_profile_service.dart';

class CustomSellerListTile extends StatelessWidget {
  const CustomSellerListTile({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final sellerIdentifier = product.sellerId;

    void openShopDetails() {
      if (sellerIdentifier.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seller data is not available')),
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CustomerShopDetailsScreen(sellerId: sellerIdentifier),
        ),
      );
    }

    return FutureBuilder<SellerModel>(
      future: getsellerdata(sellerIdentifier),
      builder: (context, snapshot) {
        final seller = snapshot.data?.mergedWith(product.seller) ?? product.seller;

        return InkWell(
          onTap: openShopDetails,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                _SellerAvatar(avatarUrl: seller.avatarUrl),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seller.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.t_16w600.copyWith(
                          color: blackDegree,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        seller.displaySpecialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.t_12w500.copyWith(
                          color: subTitleColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          _SellerTag(text: seller.displayBadge),
                          _SellerTag(text: seller.displayLocation),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: openShopDetails,
                  child: CustomTextContainer(
                    verticalpadding: 8,
                    horizontalpadding: 14,
                    borderRadius: 14,
                    text: 'View Shop',
                    textstyle: AppTextStyles.t_12w700.copyWith(
                      color: commonColor,
                    ),
                    bordercolor: commonColor.withValues(alpha: 0.18),
                    backGroundColor: commonColor.withValues(alpha: 0.08),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SellerAvatar extends StatelessWidget {
  const _SellerAvatar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28.r,
      backgroundColor: commonColor.withValues(alpha: 0.10),
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null
          ? SvgPicture.asset(
              'assets/images/unknown_user_icon.svg',
              width: 24.w,
              height: 24.w,
            )
          : null,
    );
  }
}

class _SellerTag extends StatelessWidget {
  const _SellerTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: customerbackGroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: AppTextStyles.t_10w600.copyWith(color: subTitleColor),
      ),
    );
  }
}
