import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String street;
  final String city;
  final String governorate;
  final String country;
  final String zipCode;

  const AddressModel({
    this.street = '',
    this.city = '',
    this.governorate = '',
    this.country = '',
    this.zipCode = '',
  });

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'governorate': governorate,
        'country': country,
        'zipCode': zipCode,
      };

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      governorate: json['governorate'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role; // 'customer' | 'seller' | 'admin'
  final String? avatar;
  final AddressModel? address;
  final double wallet;
  final String? fcmToken;
  final bool isActive;
  final DateTime? createdAt;

  const UserModel({
    this.id = '',
    required this.name,
    required this.email,
    this.phone,
    this.role = 'customer',
    this.avatar,
    this.address,
    this.wallet = 0.0,
    this.fcmToken,
    this.isActive = true,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'avatar': avatar,
        'address': address?.toJson(),
        'wallet': wallet,
        'fcmToken': fcmToken,
        'isActive': isActive,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      };

  factory UserModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return UserModel(
      id: id ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'customer',
      avatar: json['avatar'],
      address: json['address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['address'])
          : null,
      wallet: (json['wallet'] as num?)?.toDouble() ?? 0.0,
      fcmToken: json['fcmToken'],
      isActive: json['isActive'] ?? true,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
