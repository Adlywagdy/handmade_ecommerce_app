import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/amountcontainerbutton.dart';

class CustomerCartScreen extends StatelessWidget {
  final List<ProductModel> cartItems;
  const CustomerCartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: customerbackGroundColor,
              scrolledUnderElevation: 0,
              centerTitle: true,

              title: Text(
                'Your Cart',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blackDegree,
                  fontSize: 18.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.56,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(color: commonColor.withValues(alpha: .05)),
            ),
            SliverList.builder(
              itemBuilder: (context, index) {
                return CartProductItem(cartItems: [cartItems[index]]);
              },
              itemCount: cartItems.length,
            ),
            SliverToBoxAdapter(child: OrderSummary()),
            SliverToBoxAdapter(child: CopounRow()),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 30).h,
                child: Column(
                  children: [
                    Divider(color: commonColor.withValues(alpha: .05)),

                    CustomElevatedButton(
                      buttoncolor: commonColor,
                      onPressed: () {},
                      child: Text(
                        'Proceed to Checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CopounRow extends StatelessWidget {
  const CopounRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      children: [
        Expanded(
          flex: 3.w.toInt(),
          child: TextFormField(
            cursorColor: commonColor,

            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              filled: true,
              hint: Text(
                'Promo code',
                style: TextStyle(
                  color: subTitleColor,
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: commonColor),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: commonColor.withValues(alpha: .2),
                ),
              ),
              border: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: commonColor.withValues(alpha: .2),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1.w.toInt(),
          child: CustomTextContainer(
            buttontext: "Apply",
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            horizontalpadding: 24.w,
            verticalpadding: 12.h,
            backGroundColor: commonColor.withValues(alpha: .1),
          ),
        ),
      ],
    );
  }
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
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
      child: Column(
        spacing: 12.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              color: blackDegree,
              fontSize: 18.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.56,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  color: darkblue,
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              Text(
                '\$325.00',
                style: TextStyle(
                  color: blackDegree,
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee',
                style: TextStyle(
                  color: darkblue,
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              Text(
                '\$12.50',
                style: TextStyle(
                  color: blackDegree,
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount',
                style: TextStyle(
                  color: darkblue,
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              Text(
                '-\$0.00',
                style: TextStyle(
                  color: darkgreen,
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
              ),
            ],
          ),
          Divider(color: commonColor.withValues(alpha: .05)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  color: blackDegree,
                  fontSize: 16.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
              Text(
                '\$337.50',
                style: TextStyle(
                  color: commonColor,
                  fontSize: 20.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                  height: 1.40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
