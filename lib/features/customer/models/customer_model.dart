import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';

class CustomerModel {
  final String name;
  final String? email;
  final String? phone;
  final AddressModel? address;
  final String? password;
  final String? image;

  CustomerModel({
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.password,
    this.image,
  });
}
