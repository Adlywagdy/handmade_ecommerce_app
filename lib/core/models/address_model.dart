import 'package:handmade_ecommerce_app/core/utils/parse_utils.dart';

class AddressModel {
  final String? addresstitle;
  final String addressdescription;
  final int zipCode;
  final String? city;
  final String? country;

  AddressModel({
    this.addresstitle,
    required this.addressdescription,
    required this.zipCode,
    this.city,
    this.country,
  });

  String get street => addresstitle ?? addressdescription;
  String get postalCode => zipCode.toString();

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      addresstitle:
          map['addresstitle']?.toString() ??
          map['street']?.toString() ??
          map['governorate']?.toString(),
      addressdescription:
          (map['addressdescription'] ?? map['street'] ?? '').toString(),
      zipCode: parseInt(map['zipCode'] ?? map['postalCode']) ?? 0,
      city: map['city']?.toString() ?? map['governorate']?.toString(),
      country: map['country']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'zipCode': zipCode,
      'country': country,
    };
  }
}
