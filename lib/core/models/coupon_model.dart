import 'package:cloud_firestore/cloud_firestore.dart';

enum DiscountType { percentage, fixed }

class CouponModel {
  final String id;
  final String code;
  final DiscountType discountType;
  final double discountValue;
  final bool isActive;
  final int maxUses;
  final int usedCount;
  final double minOrderAmount;
  final DateTime? expiryDate;
  final DateTime? createdAt;

  const CouponModel({
    this.id = '',
    required this.code,
    this.discountType = DiscountType.percentage,
    required this.discountValue,
    this.isActive = true,
    this.maxUses = 0,
    this.usedCount = 0,
    this.minOrderAmount = 0,
    this.expiryDate,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'discountType': discountType.name,
        'discountValue': discountValue,
        'isActive': isActive,
        'maxUses': maxUses,
        'usedCount': usedCount,
        'minOrderAmount': minOrderAmount,
        'expiryDate':
            expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
        'createdAt':
            createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      };

  factory CouponModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return CouponModel(
      id: id ?? json['id'] ?? '',
      code: json['code'] ?? '',
      discountType: DiscountType.values.firstWhere(
        (e) => e.name == json['discountType'],
        orElse: () => DiscountType.percentage,
      ),
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] ?? true,
      maxUses: json['maxUses'] ?? 0,
      usedCount: json['usedCount'] ?? 0,
      minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble() ?? 0,
      expiryDate: (json['expiryDate'] as Timestamp?)?.toDate(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);

  bool get hasUsesLeft => maxUses == 0 || usedCount < maxUses;

  bool get isValid => isActive && !isExpired && hasUsesLeft;
}
