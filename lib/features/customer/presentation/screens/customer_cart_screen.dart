import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/addresscolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/cartproductitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/copounrow.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ordersummary.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/paymentcolumn.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
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
                await BlocProvider.of<CartCubit>(context).getcartProducts();
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
            BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) {
                return current is GetcartSuccessedstate ||
                    current is GetcartLoadingstate ||
                    current is GetcartFailedstate ||
                    current is AddcartproductSuccessedstate ||
                    current is DeletecartproductSuccessedstate;
              },
              builder: (context, state) {
                if (state is GetcartFailedstate) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Failed to load cart. Please try again.',
                        style: AppTextStyles.t_14w500.copyWith(
                          color: redDegree,
                        ),
                      ),
                    ),
                  );
                } else if (state is GetcartSuccessedstate &&
                    state.cartproducts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Your cart is empty.',
                            style: AppTextStyles.t_24w500.copyWith(
                              color: subTitleColor,
                            ),
                          ),
                          Text(
                            'Start adding your favorite products!',
                            style: AppTextStyles.t_14w500.copyWith(
                              color: subTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is GetcartSuccessedstate) {
                  return SliverList.builder(
                    itemBuilder: (context, index) {
                      return CartProductItem(
                        product: state.cartproducts[index],
                      );
                    },
                    itemCount: state.cartproducts.length,
                  );
                } else {
                  return SliverList.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 14.h),
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(
                            color: commonColor.withValues(alpha: .08),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12.r),
                          leading: Container(
                            height: 74.h,
                            width: 74.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffEFEDEA),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Container(
                              height: 14.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xffE5E7EB),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Container(
                                height: 12.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xffE5E7EB),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                height: 12.h,
                                width: 70.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xffE5E7EB),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) {
                return current is GetOrderSummarySuccessState ||
                    current is GetOrderSummaryLoadingState ||
                    current is GetOrderSummaryFailedState ||
                    current is GetcartSuccessedstate;
              },
              builder: (context, state) {
                if (context.read<CartCubit>().cartProductsList.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }

                if (state is GetOrderSummarySuccessState) {
                  return SliverToBoxAdapter(
                    child: OrderSummary(
                      orderPaymentDetails: state.orderSummary,
                    ),
                  );
                }

                if (state is GetOrderSummaryFailedState) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Failed to load order summary. Please try again.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.t_14w500.copyWith(
                            color: redDegree,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Center(
                      child: CircularProgressIndicator(color: commonColor),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) {
                return current is GetOrderSummarySuccessState ||
                    current is GetOrderSummaryLoadingState ||
                    current is GetOrderSummaryFailedState ||
                    current is GetcartSuccessedstate;
              },
              builder: (context, state) {
                if (state is GetOrderSummarySuccessState &&
                    context.read<CartCubit>().cartProductsList.isNotEmpty) {
                  return const SliverToBoxAdapter(child: CopounRow());
                }
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
            BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) {
                return current is GetOrderSummarySuccessState ||
                    current is GetOrderSummaryLoadingState ||
                    current is GetOrderSummaryFailedState ||
                    current is GetcartSuccessedstate;
              },
              builder: (context, state) {
                if (state is GetOrderSummarySuccessState &&
                    context.read<CartCubit>().cartProductsList.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0).h,
                      child: const AddressColumn(),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
            const SliverToBoxAdapter(child: PaymentColumn()),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 15).h,
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
