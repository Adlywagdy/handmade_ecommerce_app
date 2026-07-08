abstract class SellerStatus {
  SellerStatus._();

  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String rejected = 'rejected';

  static bool isApproved(String? status) =>
      status?.trim().toLowerCase() == approved;
}
