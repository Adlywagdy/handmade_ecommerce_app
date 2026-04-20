import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';

List<OrderModel> ordersListdata = [
  OrderModel(
    customer: CustomerModel(
      name: "adly",
      email: "adly.wagdy@ayady.com",
      password: "456789",
      phone: "0651616161681",
      image: "assets/images/splash.jpeg",
    ),
    orderid: '#AY-84920',
    products: productsListData,
    payment: PaymentDetailsModel(
      paymentMethod: 'Credit Card',
      totalPrice: 500.00,
      discount: 50.00,
    ),
    orderDate: DateTime.now().subtract(const Duration(days: 2)),
    status: .delivered,
    address: AddressModel(
      addressdescription: "addressdescription",
      zipCode: 12345,
      city: "city",
      country: "country",
    ),
  ),
  OrderModel(
    customer: CustomerModel(
      name: "adly",
      email: "adly.wagdy@ayady.com",
      password: "456789",
      phone: "0651616161681",
      image: "assets/images/splash.jpeg",
    ),
    orderid: '#AY-84920',
    products: productsListData,
    payment: PaymentDetailsModel(
      paymentMethod: 'Credit Card',
      totalPrice: 500.00,
      discount: 50.00,
    ),
    orderDate: DateTime.now().subtract(const Duration(days: 2)),
    address: AddressModel(
      addressdescription: "addressdescription",
      zipCode: 12345,
      city: "city",
      country: "country",
    ),
    status: .confirmed,
  ),
];
