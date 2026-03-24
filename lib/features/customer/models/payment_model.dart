import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class PaymentDetailsModel {
  final String? paymentMethod;
  final double? subtotalPrice;
  final double? totalPrice;
  final double? deliveryFee;
  final double? discount;
  final String? image;

  /////these will be added later to cubit

  static double? ordersubtotalPrice = 0;
  static double? ordertotalPrice = 0;
  static double? orderdeliveryFee;
  static double? orderdiscount;
  static double calculateOrdersubTotalPrice({
    required List<ProductModel> orderproducts,
  }) {
    for (int i = 0; i < orderproducts.length; i++) {
      ordersubtotalPrice = ordersubtotalPrice! + orderproducts[i].price;
    }
    return ordersubtotalPrice!;
  }

  static double calculateOrderTotalPrice({
    required double subtotalPrice,
    required double deliveryFee,
    double? discount = 0,
  }) {
    ordertotalPrice = subtotalPrice + deliveryFee - (discount!);
    return ordertotalPrice!;
  }
  //////////////////////////////////////////////////////////////////////////////////////////

  PaymentDetailsModel({
    this.paymentMethod,
    this.subtotalPrice,
    this.totalPrice,
    this.deliveryFee,
    this.discount = 0,
    this.image,
  });
}
