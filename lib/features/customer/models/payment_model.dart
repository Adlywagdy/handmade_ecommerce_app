class PaymentDetailsModel {
  final String? paymentMethod;
  final double? subtotalPrice;
  final double? totalPrice;
  final double? deliveryFee;
  final double? discount;
  final String? currency;
  final String? imagePath;
  PaymentDetailsModel({
    this.paymentMethod,
    this.subtotalPrice,
    this.totalPrice,
    this.deliveryFee,
    this.discount = 0,
    this.imagePath,
    this.currency = "USD",
  });

  factory PaymentDetailsModel.copywith(
    PaymentDetailsModel product, {
    String? paymentMethod,
  }) {
    return PaymentDetailsModel(
      paymentMethod: paymentMethod ?? product.paymentMethod,
      subtotalPrice: product.subtotalPrice,
      totalPrice: product.totalPrice,
      deliveryFee: product.deliveryFee,
      discount: product.discount,
      imagePath: product.imagePath,
      currency: product.currency,
    );
  }
}
