import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';

class OrderModel {
  final CustomerModel customer;

  final String? orderid;
  final List<ProductModel> products;

  final OrderStatus? status;
  final DateTime? orderDate;
  final PaymentDetailsModel? payment;

  OrderModel({
    required this.customer,
    required this.products,
    this.status,
    required this.orderid,
    this.orderDate,
    this.payment,
  });
}

enum OrderStatus { pending, preparing, shipped, delivered, cancelled }
