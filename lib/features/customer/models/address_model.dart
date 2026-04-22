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
    final zip = map['zipCode'] ?? map['postalCode'] ?? 0;
    return AddressModel(
      addresstitle:
          map['addresstitle']?.toString() ??
          map['street']?.toString() ??
          map['governorate']?.toString(),
      addressdescription: (map['addressdescription'] ?? map['street'] ?? '')
          .toString(),
      zipCode: zip is int ? zip : int.tryParse(zip.toString()) ?? 0,
      city: map['city']?.toString() ?? map['governorate']?.toString(),
      country: map['country']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addresstitle': addresstitle,
      'addressdescription': addressdescription,
      'zipCode': zipCode,
      'street': street,
      'postalCode': postalCode,
      'city': city,
      'governorate': city,
      'country': country,
    };
  }
}
