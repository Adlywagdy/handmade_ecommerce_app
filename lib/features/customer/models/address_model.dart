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
}
