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

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      image: map['image']?.toString(),
      address: map['address'] is Map<String, dynamic>
          ? AddressModel.fromMap(map['address'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'address': address?.toMap(),
    };
  }
}
