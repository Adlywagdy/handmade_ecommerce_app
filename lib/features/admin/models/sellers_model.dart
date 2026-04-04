enum SellerStatus { pending, approved, rejected }

class SellerData {
  final int sellerId;
  final String name;
  final String email;
  final String specialty;
  final String submittedDate;
  final String? badge;
  final SellerStatus status;

  const SellerData({
    required this.sellerId,
    required this.name,
    required this.email,
    required this.specialty,
    required this.submittedDate,
    required this.status,
    this.badge,
  });
}

