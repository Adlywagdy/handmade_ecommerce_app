import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

double calculateOrdersubTotalPrice({required List<ProductModel> cartproducts}) {
  double ordersubtotalPrice = 0;
  for (int i = 0; i < cartproducts.length; i++) {
    ordersubtotalPrice += cartproducts[i].price * cartproducts[i].quantity;
  }
  return ordersubtotalPrice;
}

List<Map<String, double>> copounslist = [
  {'SAVE20': 20},
  {'DISCOUNT10': 10},
  {'ADLY': 30},
  {'WELCOME15': 15},
  {'SUMMER25': 25},
];

double applycoupon(String coupon) {
  if (checkcopoun(coupon)) {
    showSnack(
      title: "Applied coupon",
      message: "Coupon $coupon has been applied successfully.",
      bgColor: Colors.green,
      icon: Icons.error_outline,
    );
    return copounslist.firstWhere(
      (element) => element.containsKey(coupon),
    )[coupon]!;
  } else {
    return 0.0;
  }
}

bool checkcopoun(String coupon) {
  if (copounslist.any((element) => element.containsKey(coupon))) {
    return true;
  } else if (coupon.isNotEmpty) {
    showSnack(
      title: "Invalid coupon",
      message: "Please enter a valid coupon",
      bgColor: redDegree,
      icon: Icons.error_outline,
    );
    return false;
  } else {
    return false;
  }
}
  //////////////////////////////////////////////////////////////////////////////////////////