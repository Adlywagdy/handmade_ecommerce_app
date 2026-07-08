import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String nameEN;
  final String nameAR;
  final String? icon;
  final int order;
  final bool isActive;
  final int productsCount;
  final DateTime? createdAt;

  const CategoryModel({
    this.id = '',
    required this.nameEN,
    this.nameAR = '',
    this.icon,
    this.order = 0,
    this.isActive = true,
    this.productsCount = 0,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'nameEN': nameEN,
        'nameAR': nameAR,
        'icon': icon,
        'order': order,
        'isActive': isActive,
        'productsCount': productsCount,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      };

  factory CategoryModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return CategoryModel(
      id: id ?? json['id'] ?? '',
      nameEN: json['nameEN'] ?? json['name'] ?? '',
      nameAR: json['nameAR'] ?? '',
      icon: json['icon'],
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
      productsCount: json['productsCount'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
