import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { sale, refund }

class TransactionModel {
  final String id;
  final String orderId;
  final String sellerId;
  final double amount;
  final double commission;
  final double sellerEarning;
  final double commissionRate;
  final String currency;
  final TransactionType type;
  final String status;
  final DateTime? createdAt;

  const TransactionModel({
    this.id = '',
    required this.orderId,
    required this.sellerId,
    required this.amount,
    required this.commission,
    required this.sellerEarning,
    this.commissionRate = 0.10,
    this.currency = 'EGP',
    this.type = TransactionType.sale,
    this.status = 'completed',
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'sellerId': sellerId,
        'amount': amount,
        'commission': commission,
        'sellerEarning': sellerEarning,
        'commissionRate': commissionRate,
        'currency': currency,
        'type': type.name,
        'status': status,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return TransactionModel(
      id: id ?? json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      sellerId: json['sellerId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      commission: (json['commission'] as num?)?.toDouble() ?? 0.0,
      sellerEarning: (json['sellerEarning'] as num?)?.toDouble() ?? 0.0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.10,
      currency: json['currency'] ?? 'EGP',
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.sale,
      ),
      status: json['status'] ?? 'completed',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
