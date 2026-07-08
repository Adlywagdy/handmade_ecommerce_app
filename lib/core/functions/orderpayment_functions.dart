import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/data/models/coupon_model.dart';

double calculateOrdersubTotalPrice({required List<ProductModel> cartproducts}) {
  return cartproducts.fold(
    0,
    (subtotal, product) => subtotal + (product.price * product.quantity),
  );
}

String _normalizeCoupon(String coupon) => coupon.trim().toUpperCase();

CouponModel? findCoupon(String coupon, List<CouponModel> coupons) {
  final normalizedCoupon = _normalizeCoupon(coupon);
  if (normalizedCoupon.isEmpty) return null;
  for (final c in coupons) {
    if (c.code.toUpperCase() == normalizedCoupon) return c;
  }
  return null;
}

bool isValidCoupon(String coupon, List<CouponModel> coupons) {
  final found = findCoupon(coupon, coupons);
  return found != null && found.isValid;
}

double getCouponDiscount(
  String coupon,
  List<CouponModel> coupons, {
  required double subtotal,
}) {
  final found = findCoupon(coupon, coupons);
  if (found == null || !found.isValid) return 0;

  if (subtotal < found.minOrderAmount) return 0;

  if (found.discountType == DiscountType.percentage) {
    return subtotal * (found.discountValue / 100);
  }
  return found.discountValue;
}

double applyCoupon(
  String coupon,
  List<CouponModel> coupons, {
  required double subtotal,
}) {
  final normalizedCoupon = _normalizeCoupon(coupon);
  final found = findCoupon(coupon, coupons);

  if (found != null && found.isValid) {
    if (subtotal < found.minOrderAmount) {
      showSnack(
        title: "Minimum not met",
        message:
            "Minimum order ${found.minOrderAmount.toStringAsFixed(0)} EGP required.",
        bgColor: Colors.orange,
        icon: Icons.info_outline,
      );
      return 0;
    }

    final discount = getCouponDiscount(coupon, coupons, subtotal: subtotal);
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
