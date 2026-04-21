import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/functions/is_already_exicted_fun.dart';
import 'package:handmade_ecommerce_app/core/functions/orderpayment_functions.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/customer_cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_cartdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/customer_cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/constants.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/payment_webview.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/paymob_manager/paymob_manager.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_models.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_service.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  List<ProductModel> cartProductsList = [];
  AddressModel? selectedOrderAddress;
  String selectedPaymentMethod = "Visa";
  PaymentDetailsModel? currentOrderSummary;
  String walletPhonenumber = "";

  /* ------------------------------------------- */
  Future<void> getcartProducts() async {
    emit(GetcartLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      cartProductsList =
          carttProductsdata; // Replace with actual data from Firestore
      emit(GetcartSuccessedstate(cartproducts: cartProductsList));
      getOrderSummary(products: cartProductsList);
    } catch (e) {
      emit(GetcartFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  Future<void> addCartProducts(ProductModel product) async {
    emit(AddcartproductLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      if (isItemExictedFun(
        productslist: cartProductsList,
        productID: product.id,
      )) {
        cartProductsList.firstWhere((item) => item.id == product.id).quantity =
            cartProductsList
                .firstWhere((item) => item.id == product.id)
                .quantity +
            1;
      } else {
        cartProductsList.add(
          ProductModel.copywith(product),
        ); // Replace with actual logic to add product to wishlist in Firestore
        showSnack(
          title: "Success",
          message: "${product.name} has been added to your cart.",
          bgColor: Colors.green,
          icon: Icons.check_circle_outline,
        );
      }
      emit(AddcartproductSuccessedstate());
      emit(GetcartSuccessedstate(cartproducts: cartProductsList));
      getOrderSummary(products: cartProductsList);
    } catch (e) {
      emit(AddcartproductFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  Future<void> deleteCartProducts(ProductModel product) async {
    emit(DeletecartproductLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      if (isItemExictedFun(
        productslist: cartProductsList,
        productID: product.id,
      )) {
        cartProductsList.firstWhere((item) => item.id == product.id).quantity =
            cartProductsList
                .firstWhere((item) => item.id == product.id)
                .quantity -
            1;
        if (cartProductsList
                .firstWhere((item) => item.id == product.id)
                .quantity ==
            0) {
          cartProductsList.remove(
            cartProductsList.firstWhere((item) => item.id == product.id),
          );
          showSnack(
            title: "Product Deleted",
            message: "${product.name} has been removed from your cart.",
            bgColor: redDegree,
            icon: CupertinoIcons.delete,
          );
        }
        emit(DeletecartproductSuccessedstate());
        emit(GetcartSuccessedstate(cartproducts: cartProductsList));
        getOrderSummary(products: cartProductsList);
      }
    } catch (e) {
      emit(DeletecartproductFailedstate(errorMessage: e.toString()));
    }
  } /*------------------------------------------- */

  Future<void> getOrderSummary({
    required List<ProductModel> products,
    String? coupon = "",
    double deliveryFee = 0,
  }) async {
    emit(GetOrderSummaryLoadingState());
    try {
      // Simulate a delay for loading order summary
      await Future.delayed(const Duration(seconds: 2));
      final ordersubtotalPrice = calculateOrdersubTotalPrice(
        cartproducts: products,
      );
      final double discount = applycoupon(coupon!);
      currentOrderSummary = PaymentDetailsModel(
        subtotalPrice: ordersubtotalPrice,
        totalPrice: ordersubtotalPrice + deliveryFee - discount,
        deliveryFee: deliveryFee,
        discount: discount,
        paymentMethod: selectedPaymentMethod,
        currency: "USD",
      );
      emit(
        GetOrderSummarySuccessState(
          subtotalPrice: ordersubtotalPrice,
          totalPrice: ordersubtotalPrice + deliveryFee - discount,
          deliveryFee: deliveryFee,
          discount: discount,
        ),
      );
    } catch (e) {
      emit(GetOrderSummaryFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> getOrderaddress({required AddressModel address}) async {
    emit(GetOrderaddressLoadingState());
    try {
      selectedOrderAddress = address;
      emit(GetOrderaddressSuccessState(orderAddress: selectedOrderAddress!));
    } catch (e) {
      emit(GetOrderaddressFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> makePayment(
    PaymentDetailsModel paymentmethoddetails,
    BuildContext context,
  ) async {
    emit(MakePaymentLoadingState());

    try {
      final manager = PaymobManager();
      final paymentMethod =
          paymentmethoddetails.paymentMethod ?? selectedPaymentMethod;
      final amount = paymentmethoddetails.totalPrice?.round();

      if (amount == null) {
        throw Exception("Payment amount is missing");
      }

      switch (paymentMethod) {
        case 'Visa':
          final paymentKey = await manager.getPaymentKey(
            amount: amount * 50,
            currency: "EGP",
            integrationId: Constants.integrationIdCard,
          );

          final url =
              "https://accept.paymob.com/api/acceptance/iframes/${Constants.iframeId}?payment_token=$paymentKey";

          if (!context.mounted) {
            throw Exception("Payment screen is no longer available");
          }

          final paymentResult = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => PaymentWebView(paymentUrl: url)),
          );

          if (paymentResult != true) {
            throw Exception("Visa payment was not completed");
          }
          break;
        case 'PayPal':
          final paypalSuccess = await PayPAlService.makePayPalpayment(
            context,
            AmountPaymentModel(
              total: paymentmethoddetails.totalPrice.toString(),
              currency: "USD",
              details: Details(
                subtotal: paymentmethoddetails.subtotalPrice.toString(),
                shipping: paymentmethoddetails.deliveryFee.toString(),
                shippingDiscount: paymentmethoddetails.discount!.toInt(),
              ),
            ),
            ItemListModel(
              orderslist: cartProductsList
                  .map(
                    (e) => OrderItemModel(
                      name: e.name,
                      quantity: e.quantity,
                      price: e.price.toString(),
                      currency: "USD",
                    ),
                  )
                  .toList(),
            ),
          );

          if (!paypalSuccess) {
            throw Exception("PayPal payment was not completed");
          }
          break;
        case 'Mobile Wallets':
          final customerPhone = walletPhonenumber.trim().isNotEmpty
              ? walletPhonenumber.trim()
              : BlocProvider.of<CustomerCubit>(
                  context,
                ).customerData.phone.trim();

          if (customerPhone.isEmpty) {
            throw Exception(
              "Customer phone number is required for wallet payment",
            );
          }

          final phoneRegex = RegExp(r'^(\+201|01)[0-9]{9}$');
          if (!phoneRegex.hasMatch(customerPhone)) {
            throw Exception(
              "Customer phone number is invalid for wallet payment",
            );
          }

          final paymentKey = await manager.getPaymentKey(
            amount: amount * 50,
            currency: "EGP",
            integrationId: Constants.integrationIdWallet,
          );

          final redirectUrl = await manager.payWithWallet(
            paymentKey: paymentKey,
            phone: customerPhone,
          );

          if (!context.mounted) {
            throw Exception("Payment screen is no longer available");
          }

          final paymentResult = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => PaymentWebView(paymentUrl: redirectUrl),
            ),
          );

          if (paymentResult != true) {
            throw Exception("Wallet payment was not completed");
          }
          break;
        default:
          throw Exception("Unsupported payment method: $paymentMethod");
      }

      emit(MakePaymentSuccessState());

      emit(GetcartSuccessedstate(cartproducts: cartProductsList));
    } catch (e) {
      emit(MakePaymentFailedState(e.toString()));
      rethrow;
    }
  }

  void clearCart() {
    cartProductsList.clear();
    currentOrderSummary = null;
    selectedOrderAddress = null;
    selectedPaymentMethod = "Visa";
    walletPhonenumber = "";
    emit(GetcartSuccessedstate(cartproducts: cartProductsList));
  }
}
