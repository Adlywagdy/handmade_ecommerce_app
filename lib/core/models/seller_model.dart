class SellerModel {
  final String name;
  final String email;
  final String specialty;
  final String submittedDate;
  final String? badge;
  final String? image;
  final String? location;

  const SellerModel({
    required this.name,
    required this.email,
    required this.specialty,
    required this.submittedDate,
    this.badge,
    this.image,
    this.location,
  });
}
