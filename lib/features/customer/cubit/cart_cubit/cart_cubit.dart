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
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_models.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_service.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  List<ProductModel> cartProductsList = [];
  AddressModel? selectedOrderAddress;
  String selectedPaymentMethod = "Credit Card";
  PaymentDetailsModel? currentOrderSummary;
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
    String? currency,
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
        totalPrice: ordersubtotalPrice + deliveryFee - discount,
        subtotalPrice: ordersubtotalPrice,
        discount: discount,
        deliveryFee: deliveryFee,
        currency: currency ?? "USD",
        paymentMethod: selectedPaymentMethod,
      );
      emit(GetOrderSummarySuccessState(orderSummary: currentOrderSummary));
    } catch (e) {
      emit(GetOrderSummaryFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> getOrderaddress({
    required AddressModel address,
    bool issetdefault = false,
    required BuildContext context,
  }) async {
    emit(GetOrderaddressLoadingState());
    try {
      if (issetdefault) {
        BlocProvider.of<CustomerCubit>(context).customerData.address = address;
      }
      // Simulate a delay for loading featured products
      await Future.delayed(const Duration(seconds: 2), () {});
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
      await Future.delayed(const Duration(seconds: 2), () {});

      switch (paymentmethoddetails.paymentMethod) {
        case 'Credit Card':
          // Handle Credit Card payment logic here
          break;
        case 'PayPal':
          PayPAlService.makePayPalpayment(
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
              orderslist: BlocProvider.of<CartCubit>(context).cartProductsList
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

          break;
        case 'Mobile Wallets':
          // Handle Mobile Wallets payment logic here
          break;
      }

      emit(MakePaymentSuccessState());
      emit(GetcartSuccessedstate(cartproducts: cartProductsList));
    } catch (e) {
      emit(MakePaymentFailedState(e.toString()));
    }
  }
}
