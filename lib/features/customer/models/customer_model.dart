import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';

class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String provider;
  AddressModel? address;

  final String? image;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'customer',
    this.provider = '',
    this.address,

    this.image = "",
  });

  factory CustomerModel.empty() {
    return CustomerModel(
      id: '',
      name: '',
      email: '',
      phone: '',
      role: 'customer',
      provider: '',

      image: null,
    );
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: (map['uid'] ?? map['id'])?.toString() ?? '',
      name: (map['fullName'] ?? map['name'])?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      role: map['role']?.toString() ?? 'customer',
      provider: map['provider']?.toString() ?? '',

      image: map['image']?.toString(),
      address: map['address'] is Map<String, dynamic>
          ? AddressModel.fromMap(map['address'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'fullName': name,

      'email': email,
      'phone': phone,
      'role': role,
      'provider': provider,
      'image': image,
      'address': address?.toMap(),
    };
  }
}
