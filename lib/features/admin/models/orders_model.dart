enum OrderStatus { pending, active, delivered, cancelled }

class OrderModel {
  final String orderId;
  final String customerName;
  final String sellerName;
  final String date;
  final double price;
  final String currency;
  final OrderStatus status;

  const OrderModel({
    required this.orderId,
    required this.customerName,
    required this.sellerName,
    required this.date,
    required this.price,
    required this.status,
    this.currency = '\$',
  });
}
