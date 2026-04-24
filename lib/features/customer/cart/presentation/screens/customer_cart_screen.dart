import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';
import 'package:handmade_ecommerce_app/features/customer/checkout/presentation/widgets/addresscolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/presentation/widgets/cartproductitem.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/presentation/widgets/copounrow.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/presentation/widgets/ordersummary.dart';
import 'package:handmade_ecommerce_app/features/customer/checkout/presentation/widgets/paymentcolumn.dart';

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
                  return SliverFillRemaining(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                if (BlocProvider.of<CartCubit>(
                  context,
                ).cartProductsList.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox());
                } else if (state is GetOrderSummarySuccessState) {
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        OrderSummary(
                          subtotalPrice: state.subtotalPrice,
                          totalPrice: state.totalPrice,
                          deliveryFee: state.deliveryFee,
                          discount: state.discount,
                        ),
                        SizedBox(height: 8.h),
                        CopounRow(),
                        SizedBox(height: 16.h),
                        AddressColumn(),
                        SizedBox(height: 16.h),
                        PaymentColumn(),
                        Divider(color: commonColor.withValues(alpha: .2)),
                        SizedBox(height: 16.h),
                        CheckoutButton(),
                        SizedBox(height: 16.h),
                        Text(
                          'By clicking confirm, you agree to our Terms of Service and Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.t_12w400.copyWith(
                            color: subTitleColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is GetOrderSummaryFailedState) {
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
                } else {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(
                        child: CircularProgressIndicator(color: commonColor),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listenWhen: (previous, current) => current is PlaceOrderFailedState,
      listener: (context, state) {
        if (state is PlaceOrderFailedState) {
          final error = state.errorMessage.toLowerCase();
          final isCancelled =
              error.contains('not completed') ||
              error.contains('cancel') ||
              error.contains('closed');

          showSnack(
            title: isCancelled ? "Payment cancelled" : "Checkout failed",
            message: isCancelled
                ? "Payment was cancelled. Complete payment to place the order."
                : state.errorMessage,
            bgColor: redDegree,
            icon: Icons.error_outline,
          );
        }
      },
      buildWhen: (previous, current) {
        return current is PlaceOrderSuccessState ||
            current is PlaceOrderLoadingState ||
            current is PlaceOrderFailedState;
      },
      builder: (context, state) {
        final isLoading = state is PlaceOrderLoadingState;

        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 15).h,
          child: CustomElevatedButton(
            buttoncolor: commonColor,
            onPressed: isLoading
                ? null
                : () async {
                    final cartCubit = context.read<CartCubit>();
                    final orderCubit = context.read<OrderCubit>();
                    final customerCubit = context.read<CustomerCubit>();

                    if (cartCubit.selectedOrderAddress == null) {
                      showSnack(
                        title: "Address required",
                        message:
                            "Please add an address to proceed to checkout.",
                        bgColor: redDegree,
                      );
                      return;
                    }

                    if (cartCubit.currentOrderSummary == null) {
                      showSnack(
                        title: "Payment details missing",
                        message: "Please wait for order summary to load.",
                        bgColor: redDegree,
                      );
                      return;
                    }

                    final orderPayment = PaymentDetailsModel.copywith(
                      cartCubit.currentOrderSummary!,
                      paymentMethod: cartCubit.selectedPaymentMethod,
                    );

                    await orderCubit.placeNewOrder(
                      CustomerOrderModel(
                        customer: customerCubit.customerData,
                        products: cartCubit.cartProductsList,
                        status: .pending,
                        address: cartCubit.selectedOrderAddress!,
                        orderid: "#AY-${orderCubit.orderID++}",
                        payment: orderPayment,
                        orderDate: DateTime.now(),
                      ),
                      context,
                    );
                  },
            child: Builder(
              builder: (context) {
                if (state is PlaceOrderLoadingState) {
                  return CircularProgressIndicator(color: Colors.white);
                } else if (state is PlaceOrderFailedState) {
                  return Text(
                    'Checkout Failed. Try Again.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.t_16w700.copyWith(color: Colors.white),
                  );
                } else if (state is PlaceOrderSuccessState) {
                  return Text(
                    'Checkout Successful!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.t_16w700.copyWith(color: Colors.white),
                  );
                }

                return Text(
                  'Proceed to Checkout',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.t_16w700.copyWith(color: Colors.white),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
