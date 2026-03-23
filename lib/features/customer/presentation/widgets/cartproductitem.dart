import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/amountcontainerbutton.dart';

class CartProductItem extends StatelessWidget {
  const CartProductItem({super.key, required this.cartItems});

  final List<ProductModel> cartItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: commonColor.withValues(alpha: .05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        spacing: 16.w,

        children: [
          Expanded(
            flex: 1,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                cartItems[0].images[0],
                height: 100.h,
                width: 100.w,
                fit: BoxFit.fill,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        cartItems[0].name,

                        style: TextStyle(
                          color: blackDegree,
                          fontSize: 16.sp,

                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomIconButton(
                        backgroundColor: Colors.white,
                        icon: CupertinoIcons.delete,
                        iconcolor: subTitleColor,
                        iconsize: 20.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "By ${cartItems[0].seller.specialty}${cartItems[0].seller.name}",
                  style: TextStyle(
                    color: commonColor,
                    fontSize: 12.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${cartItems[0].price.toString()}',
                      style: TextStyle(
                        color: blackDegree,
                        fontSize: 18.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.56,
                      ),
                    ),

                    AmountContainerButton(
                      circularradius: 50.r,
                      verticalpadding: 4.h,
                      horizontalpadding: 8.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
