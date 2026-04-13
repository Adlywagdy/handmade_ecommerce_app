import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar.dart';
import 'package:handmade_ecommerce_app/core/functions/orderpayment_functions.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_cartdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  List<ProductModel> cartProductsList = [];
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
    emit(AddcartLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      cartProductsList.add(
        product,
      ); // Replace with actual logic to add product to wishlist in Firestore
      emit(AddcartSuccessedstate());
      showSnack(
        title: "Success",
        message: "${product.name} has been added to your cart.",
        bgColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
      getcartProducts();
    } catch (e) {
      emit(AddcartFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  Future<void> deleteCartProducts(ProductModel product) async {
    emit(DeletecartLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      cartProductsList.remove(
        product,
      ); // Replace with actual logic to add product to wishlist in Firestore
      emit(DeletecartSuccessedstate());
      showSnack(
        title: "Product Deleted",
        message: "${product.name} has been removed from your cart.",
        bgColor: redDegree,
        icon: CupertinoIcons.delete,
      );
      getcartProducts();
    } catch (e) {
      emit(DeletecartFailedstate(errorMessage: e.toString()));
    }
  } /*------------------------------------------- */

  Future<void> getOrderSummary({
    required List<ProductModel> products,
    String? coupon = "",
    double deliveryFee = 20,
  }) async {
    emit(GetOrderSummaryLoadingState());
    try {
      // Simulate a delay for loading order summary
      await Future.delayed(const Duration(seconds: 2));
      final ordersubtotalPrice = calculateOrdersubTotalPrice(
        cartproducts: products,
      );
      final double discount = applycoupon(coupon!);
      emit(
        GetOrderSummarySuccessState(
          orderSummary: PaymentDetailsModel(
            totalPrice: ordersubtotalPrice + deliveryFee - discount,
            subtotalPrice: ordersubtotalPrice,
            discount: discount,
            deliveryFee: deliveryFee,
          ),
        ),
      );
    } catch (e) {
      emit(GetOrderSummaryFailedState(errorMessage: e.toString()));
    }
  }
}
