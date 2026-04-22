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

  factory PaymentDetailsModel.fromMap(Map<String, dynamic> map) {
    return PaymentDetailsModel(
      paymentMethod: map['paymentMethod']?.toString(),
      subtotalPrice: (map['subtotalPrice'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? map['totalAmount'] ?? 0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      imagePath: map['imagePath']?.toString(),
      currency: map['currency']?.toString() ?? 'USD',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentMethod': paymentMethod,
      'subtotalPrice': subtotalPrice,
      'totalPrice': totalPrice,
      'totalAmount': totalPrice,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'imagePath': imagePath,
      'currency': currency,
    };
  }
}
