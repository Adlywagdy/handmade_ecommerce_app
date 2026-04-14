import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar.dart';
import 'package:handmade_ecommerce_app/core/functions/is_already_exicted_fun.dart';
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
  Future<void> addCartProducts(
    ProductModel product,
    BuildContext context,
  ) async {
    emit(AddcartproductLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      if (isItemExictedFun(
        productslist: cartProductsList,
        productID: product.id,
      )) {
        BlocProvider.of<CartCubit>(context).cartProductsList
                .firstWhere((item) => item.id == product.id)
                .quantity =
            BlocProvider.of<CartCubit>(context).cartProductsList
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
  Future<void> deleteCartProducts(
    ProductModel product,
    BuildContext context,
  ) async {
    emit(DeletecartproductLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      if (isItemExictedFun(
        productslist: cartProductsList,
        productID: product.id,
      )) {
        BlocProvider.of<CartCubit>(context).cartProductsList
                .firstWhere((item) => item.id == product.id)
                .quantity =
            BlocProvider.of<CartCubit>(context).cartProductsList
                .firstWhere((item) => item.id == product.id)
                .quantity -
            1;
        if (BlocProvider.of<CartCubit>(context).cartProductsList
                .firstWhere((item) => item.id == product.id)
                .quantity ==
            0) {
          cartProductsList.remove(
            BlocProvider.of<CartCubit>(
              context,
            ).cartProductsList.firstWhere((item) => item.id == product.id),
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
