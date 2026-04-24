import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

double calculateOrdersubTotalPrice({required List<ProductModel> cartproducts}) {
  return cartproducts.fold(
    0,
    (subtotal, product) => subtotal + (product.price * product.quantity),
  );
}

const Map<String, double> _coupons = {
  'SAVE20': 20,
  'DISCOUNT10': 10,
  'ADLY': 30,
  'WELCOME15': 15,
  'SUMMER25': 25,
};

String _normalizeCoupon(String coupon) => coupon.trim().toUpperCase();

bool isValidCoupon(String coupon) {
  final normalizedCoupon = _normalizeCoupon(coupon);
  return normalizedCoupon.isNotEmpty && _coupons.containsKey(normalizedCoupon);
}

double getCouponDiscount(String coupon) {
  final normalizedCoupon = _normalizeCoupon(coupon);
  if (!isValidCoupon(normalizedCoupon)) return 0;
  return _coupons[normalizedCoupon] ?? 0;
}

double applyCoupon(String coupon) {
  final normalizedCoupon = _normalizeCoupon(coupon);
  final discount = getCouponDiscount(normalizedCoupon);
  if (discount > 0) {
    showSnack(
      title: "Applied coupon",
      message: "Coupon $normalizedCoupon has been applied successfully.",
      bgColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
    return discount;
  }

  if (normalizedCoupon.isNotEmpty) {
    showSnack(
      title: "Invalid coupon",
      message: "Please enter a valid coupon",
      bgColor: redDegree,
      icon: Icons.error_outline,
    );
  }

  return 0;
}

double applycoupon(String coupon) {
  return applyCoupon(coupon);
}

bool checkcopoun(String coupon) {
  return isValidCoupon(coupon);
}
