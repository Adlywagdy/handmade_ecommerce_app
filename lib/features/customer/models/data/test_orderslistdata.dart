import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';

List<OrderModel> ordersListdata = [
  OrderModel(
    customer: CustomerModel(name: "adly"),
    orderid: '#AY-84920',
    products: productsListData,
    payment: PaymentDetailsModel(
      paymentMethod: 'Credit Card',
      totalPrice: 500.00,
      discount: 50.00,
    ),
    orderDate: DateTime.now().subtract(const Duration(days: 2)),
    status: .delivered,
  ),
  OrderModel(
    customer: CustomerModel(name: "adly"),
    orderid: '#AY-84920',
    products: productsListData,
    payment: PaymentDetailsModel(
      paymentMethod: 'Credit Card',
      totalPrice: 500.00,
      discount: 50.00,
    ),
    orderDate: DateTime.now().subtract(const Duration(days: 2)),
    status: .confirmed,
  ),
];
