class SellerData {
  final String name;
  final String email;
  final String specialty;
  final String submittedDate;
  final String? badge;

  const SellerData({
    required this.name,
    required this.email,
    required this.specialty,
    required this.submittedDate,
    this.badge,
  });
}