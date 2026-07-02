/// Extra details a user provides when registering as a seller
class SellerApplication {
  final String specialty;
  final String phone;
  final String city;
  final String country;

  const SellerApplication({
    required this.specialty,
    required this.phone,
    this.city = '',
    this.country = '',
  });
}
