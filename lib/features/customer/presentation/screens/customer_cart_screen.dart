import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/addresscolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/cartproductitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/copounrow.dart';

import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ordersummary.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/paymentcolumn.dart';

class CustomerCartScreen extends StatelessWidget {
  // before get into this page it should trigger cubit to get the cubit to get the order products and calculate total & deleviryfee
  final OrderModel order;
  const CustomerCartScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: customerbackGroundColor,
              scrolledUnderElevation: 0,
              centerTitle: true,

              title: Text(
                'Your Cart',

                style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
              ),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 2));
              },
              builder:
                  (
                    context,
                    refreshState,
                    pulledExtent,
                    refreshTriggerPullDistance,
                    refreshIndicatorExtent,
                  ) {
                    return CupertinoSliverRefreshControl.buildRefreshIndicator(
                      context,
                      refreshState,
                      pulledExtent,
                      refreshTriggerPullDistance,
                      refreshIndicatorExtent,
                    );
                  },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0).h,
                child: Divider(color: commonColor.withValues(alpha: .2)),
              ),
            ),

            SliverList.builder(
              itemBuilder: (context, index) {
                return CartProductItem(product: order.products[index]);
              },
              itemCount: order.products.length,
            ),
            SliverToBoxAdapter(child: OrderSummary(order: order)),

            SliverToBoxAdapter(child: CopounRow()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0).h,
                child: AddressColumn(order: order),
              ),
            ),
            SliverToBoxAdapter(child: PaymentColumn()),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 15).h,
                child: Column(
                  children: [
                    Divider(color: commonColor.withValues(alpha: .2)),
                    SizedBox(height: 16.h),
                    CustomElevatedButton(
                      buttoncolor: commonColor,
                      onPressed: () {},
                      child: Text(
                        'Proceed to Checkout',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.t_16w700.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'By clicking confirm, you agree to our Terms of\nService and Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.t_12w400.copyWith(
                        color: subTitleColor,
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
