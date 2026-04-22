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
}
