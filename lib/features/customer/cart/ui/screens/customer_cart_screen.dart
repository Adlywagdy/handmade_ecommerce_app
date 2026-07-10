import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/logic/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/logic/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/logic/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/ui/widgets/delivery_details.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/ui/widgets/cartproductitem.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/ui/widgets/copounrow.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/ui/widgets/ordersummary.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/ui/widgets/paymentcolumn.dart';

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
                context.l10n.yourCart,
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
                return current is CartSuccess ||
                    current is CartLoading ||
                    current is CartError ||
                    current is AddProductSuccess ||
                    current is DeleteProductSuccess;
              },
              builder: (context, state) {
                if (state is CartError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        context.l10n.failedToLoadCart,
                        style: AppTextStyles.t_14w500.copyWith(
                          color: redDegree,
                        ),
                      ),
                    ),
                  );
                } else if (state is CartSuccess && state.products.isEmpty) {
                  return SliverFillRemaining(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.yourCartIsEmpty,
                          style: AppTextStyles.t_24w500.copyWith(
                            color: subTitleColor,
                          ),
                        ),
                        Text(
                          context.l10n.startAddingYourFavoriteProducts,
                          style: AppTextStyles.t_14w500.copyWith(
                            color: subTitleColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is CartSuccess) {
                  return SliverList.builder(
                    itemBuilder: (context, index) {
                      return CartProductItem(product: state.products[index]);
                    },
                    itemCount: state.products.length,
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
                return current is OrderSummarySuccess ||
                    current is OrderSummaryLoading ||
                    current is OrderSummaryError ||
                    current is CartSuccess;
              },
              builder: (context, state) {
                if (BlocProvider.of<CartCubit>(
                  context,
                ).cartProductsList.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox());
                } else if (state is OrderSummarySuccess) {
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
                        DeliveryDetails(),
                        SizedBox(height: 16.h),
                        PaymentColumn(),
                        Divider(color: commonColor.withValues(alpha: .2)),
                        SizedBox(height: 16.h),
                        CheckoutButton(),
                        SizedBox(height: 16.h),
                        Text(
                          context
                              .l10n
                              .byClickingConfirmYouAgreeToOurTermsOfServiceAndPrivacyPolicy,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.t_12w400.copyWith(
                            color: subTitleColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is OrderSummaryError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.l10n.failedToLoadOrderSummary,
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
    final l10n = context.l10n;
    return BlocConsumer<OrderCubit, OrderState>(
      listenWhen: (previous, current) => current is PlaceOrderError,
      listener: (context, state) {
        if (state is PlaceOrderError) {
          final error = state.message.toLowerCase();
          final isCancelled =
              error.contains('not completed') ||
              error.contains('cancel') ||
              error.contains('closed');

          showSnack(
            title: isCancelled ? l10n.paymentCancelled : l10n.checkoutFailed,
            message: isCancelled ? l10n.paymentWasCancelled : state.message,
            bgColor: redDegree,
            icon: Icons.error_outline,
          );
        }
      },
      buildWhen: (previous, current) {
        return current is PlaceOrderSuccess ||
            current is PlaceOrderLoading ||
            current is PlaceOrderError;
      },
      builder: (context, state) {
        final isLoading = state is PlaceOrderLoading;

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
                    final effectiveAddress =
                        cartCubit.selectedOrderAddress ??
                        customerCubit.customerData.address;

                    if (effectiveAddress == null) {
                      showSnack(
                        title: l10n.addressRequired,
                        message: l10n.pleaseAddAnAddress,
                        bgColor: redDegree,
                      );
                      return;
                    }

                    if (cartCubit.currentOrderSummary == null) {
                      showSnack(
                        title: l10n.paymentDetailsMissing,
                        message: l10n.pleaseWaitForOrderSummary,
                        bgColor: redDegree,
                      );
                      return;
                    }

                    final orderPayment = cartCubit.currentOrderSummary!
                        .copyWith(
                          paymentMethod: cartCubit.selectedPaymentMethod,
                        );

                    final effectivePhone =
                        cartCubit.selectedOrderPhone.isNotEmpty
                            ? cartCubit.selectedOrderPhone
                            : customerCubit.customerData.phone;

                    if (effectivePhone.isEmpty) {
                      showSnack(
                        title: l10n.phone,
                        message: l10n.phoneHint,
                        bgColor: redDegree,
                      );
                      return;
                    }

                    // fetch a new numeric order ID and set display id
                    orderCubit.orderID = await orderCubit.getNewOrderID();

                    await orderCubit.placeNewOrder(
                      CustomerOrderModel(
                        customer: customerCubit.customerData,
                        products: cartCubit.cartProductsList,
                        status: OrderStatus.pending,
                        address: effectiveAddress,
                        phone: effectivePhone,
                        orderid: "#AY-${orderCubit.orderID}",
                        payment: orderPayment,
                        orderDate: DateTime.now(),
                      ),
                      context,
                    );
                  },
            child: Builder(
              builder: (context) {
                if (state is PlaceOrderLoading) {
                  return CircularProgressIndicator(color: Colors.white);
                } else if (state is PlaceOrderError) {
                  return Text(
                    l10n.checkoutFailed,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.t_16w700.copyWith(color: Colors.white),
                  );
                } else if (state is PlaceOrderSuccess) {
                  return Text(
                    l10n.checkoutSuccessful,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.t_16w700.copyWith(color: Colors.white),
                  );
                }

                return Text(
                  l10n.proceedToCheckout,
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
