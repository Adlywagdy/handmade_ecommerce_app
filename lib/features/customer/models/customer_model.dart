import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

class CustomerModel {
  final String name;
  final String email;
  final String phone;
  AddressModel? address;
  final String password;
  final String? image;
  final List<OrderModel>? orderslist;

  CustomerModel({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    required this.password,
    this.image = "assets/images/splash.jpeg",
    this.orderslist,
  });
}
