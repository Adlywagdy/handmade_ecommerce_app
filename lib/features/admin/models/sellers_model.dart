import 'package:cloud_firestore/cloud_firestore.dart';

enum SellerStatus { pending, approved, rejected }

class SellerData {
  final String id;
  final String name;
  final String? ownerName;
  final String email;
  final String? phone;
  final String specialty;
  final String? city;
  final String? country;
  final String? avatar;
  final String? badge;
  final double rating;
  final int totalSales;
  final int totalProducts;
  final double walletBalance;
  final double commissionRate;
  final bool isActive;
  final SellerStatus status;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final DateTime? createdAt;

  const SellerData({
    this.id = '',
    required this.name,
    this.ownerName,
    required this.email,
    this.phone,
    required this.specialty,
    this.city,
    this.country,
    this.avatar,
    this.badge,
    this.rating = 0.0,
    this.totalSales = 0,
    this.totalProducts = 0,
    this.walletBalance = 0.0,
    this.commissionRate = 0.10,
    this.isActive = true,
    required this.status,
    this.submittedAt,
    this.approvedAt,
    this.createdAt,
  });

  /// Legacy convenience for screens that rendered a pre-formatted string.
  String get submittedDate => submittedAt != null
      ? '${_monthShort(submittedAt!.month)} ${submittedAt!.day}, ${submittedAt!.year}'
      : '';

  @Deprecated('Use id (String). Kept for legacy inline mock data.')
  String get sellerId => id;

  Map<String, dynamic> toJson() => {
        'name': name,
        'ownerName': ownerName,
        'email': email,
        'phone': phone,
        'specialty': specialty,
        'city': city,
        'country': country,
        'avatar': avatar,
        'badge': badge,
        'rating': rating,
        'totalSales': totalSales,
        'totalProducts': totalProducts,
        'walletBalance': walletBalance,
        'commissionRate': commissionRate,
        'isActive': isActive,
        'status': status.name,
        'submittedAt':
            submittedAt != null ? Timestamp.fromDate(submittedAt!) : null,
        'approvedAt':
            approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      };

  factory SellerData.fromJson(Map<String, dynamic> json, {String? id}) {
    return SellerData(
      id: id ?? json['id'] ?? '',
      name: json['name'] ?? '',
      ownerName: json['ownerName'],
      email: json['email'] ?? '',
      phone: json['phone'],
      specialty: json['specialty'] ?? '',
      city: json['city'],
      country: json['country'],
      avatar: json['avatar'],
      badge: json['badge'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalSales: json['totalSales'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.10,
      isActive: json['isActive'] ?? true,
      status: SellerStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SellerStatus.pending,
      ),
      submittedAt: (json['submittedAt'] as Timestamp?)?.toDate(),
      approvedAt: (json['approvedAt'] as Timestamp?)?.toDate(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  static String _monthShort(int m) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][m];
}
