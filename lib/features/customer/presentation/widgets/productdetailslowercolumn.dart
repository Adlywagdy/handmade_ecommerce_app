import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customsellerlisttile.dart';

class ProductDetailsLowerColumn extends StatelessWidget {
  const ProductDetailsLowerColumn({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSellerListTile(product: product),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            'Description',
            style: TextStyle(
              color: blackDegree,
              fontSize: 18.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.56,
            ),
          ),
        ),
        Text(
          'This exquisite Terra Vase is hand-thrown by master artisans using traditional Mediterranean techniques.\nEach piece is unique, featuring a natural matte finish and subtle variations in texture that celebrate the organic beauty of locally sourced clay. \nPerfect for dried botanicals or as a standalone sculptural piece.',
          style: TextStyle(
            color: subTitleColor,
            fontSize: 14.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.63,
          ),
        ),
        producttagsview(),
      ],
    );
  }

  Widget producttagsview() {
    return product.tags != null && product.tags!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0).h,
            child: Row(
              spacing: 8.w,
              children: [
                CustomTextContainer(
                  buttontext: product.tags![0],

                  backGroundColor: customerbackGroundColor,
                  bordercolor: commonColor.withValues(alpha: 0.1),
                  verticalpadding: 4.h,
                  horizontalpadding: 12.w,
                  textcolor: subTitleColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  borderRadius: 200,
                ),
                CustomTextContainer(
                  buttontext: product.tags![1],

                  backGroundColor: customerbackGroundColor,
                  bordercolor: commonColor.withValues(alpha: 0.1),
                  verticalpadding: 4.h,
                  horizontalpadding: 12.w,
                  textcolor: subTitleColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  borderRadius: 200,
                ),
                CustomTextContainer(
                  buttontext: product.tags![2],

                  backGroundColor: customerbackGroundColor,
                  bordercolor: commonColor.withValues(alpha: 0.1),
                  verticalpadding: 4.h,
                  horizontalpadding: 12.w,
                  textcolor: subTitleColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  borderRadius: 200,
                ),
              ],
            ),
          )
        : SizedBox(height: 16.h);
  }
}
