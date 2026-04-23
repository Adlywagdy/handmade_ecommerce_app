import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel {
  final double commissionRate;
  final String currency;
  final double deliveryFee;
  final double minOrderValue;
  final String appName;
  final String supportEmail;
  final String supportPhone;
  final DateTime? updatedAt;

  const SettingsModel({
    this.commissionRate = 0.10,
    this.currency = 'EGP',
    this.deliveryFee = 30.0,
    this.minOrderValue = 50.0,
    this.appName = 'Ayady',
    this.supportEmail = '',
    this.supportPhone = '',
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'commissionRate': commissionRate,
        'currency': currency,
        'deliveryFee': deliveryFee,
        'minOrderValue': minOrderValue,
        'appName': appName,
        'supportEmail': supportEmail,
        'supportPhone': supportPhone,
        'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      };

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.10,
      currency: json['currency'] ?? 'EGP',
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 30.0,
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble() ?? 50.0,
      appName: json['appName'] ?? 'Ayady',
      supportEmail: json['supportEmail'] ?? '',
      supportPhone: json['supportPhone'] ?? '',
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
