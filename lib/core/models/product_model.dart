import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/review_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountedPrice;
  final String currency;
  final double? totalrate;
  final int? salesCount;
  final String? status;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  int quantity;
  final List<ReviewModel>? reviews;
  final List<String> images;
  final List<String>? tags;
  final SellerModel seller;

  final CategoryModel? category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    this.currency = 'EGP',
    this.totalrate,
    this.salesCount,
    this.status,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    required this.images,
    this.category,
    required this.quantity,
    required this.seller,
    this.tags,
    this.reviews,
  });

  String? get image => images.isNotEmpty ? images.first : null;
  double get rating => totalrate ?? 0;
  String get sellerId => seller.email;
  String? get categoryId => category?.id ?? category?.categorytitle;

  factory ProductModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final imagesField = map['images'];
    final singleImage =
        map['productImage']?.toString() ?? map['imageUrl']?.toString();
    final normalizedImages = imagesField is List
        ? imagesField.map((e) => e.toString()).toList()
        : (singleImage != null && singleImage.isNotEmpty)
        ? <String>[singleImage]
        : <String>[];

    final parsedPrice = _parseDouble(map['price']) ?? 0;
    final parsedDiscountedPrice = _parseDouble(map['discountedPrice']);
    final parsedQuantity = _parseInt(map['stock'] ?? map['quantity']) ?? 0;
    final parsedRating = _parseDouble(map['rating'] ?? map['totalrate']);

    final sellerMap = map['seller'];
    final seller = sellerMap is Map<String, dynamic>
        ? SellerModel(
            name: sellerMap['name']?.toString() ?? 'Unknown Seller',
            email: sellerMap['email']?.toString() ?? '',
            specialty: sellerMap['specialty']?.toString() ?? '',
            submittedDate: sellerMap['submittedDate']?.toString() ?? '',
            badge: sellerMap['badge']?.toString(),
            image: sellerMap['image']?.toString(),
            location: sellerMap['location']?.toString(),
          )
        : SellerModel(
            name: map['sellerName']?.toString() ?? 'Unknown Seller',
            email: map['sellerId']?.toString() ?? '',
            specialty: map['sellerSpecialty']?.toString() ?? '',
            submittedDate: '',
            image: map['sellerImage']?.toString(),
            badge: map['sellerBadge']?.toString(),
            location: map['sellerLocation']?.toString(),
          );

    final categoryMap = map['category'];
    final category = categoryMap is Map<String, dynamic>
        ? CategoryModel.fromMap(categoryMap, id: map['categoryId']?.toString())
        : (map['categoryId'] != null || map['categoryName'] != null)
        ? CategoryModel(
            id: map['categoryId']?.toString(),
            categorytitle:
                (map['categoryName'] ?? map['categoryId'] ?? 'General')
                    .toString(),
          )
        : null;

    return ProductModel(
      id: id ?? map['id']?.toString() ?? map['productId']?.toString() ?? '',
      name:
          map['name']?.toString() ??
          map['productName']?.toString() ??
          map['title']?.toString() ??
          '',
      description: map['description']?.toString() ?? '',
      price: parsedPrice,
      discountedPrice: parsedDiscountedPrice,
      currency: map['currency']?.toString() ?? 'EGP',
      totalrate: parsedRating,
      salesCount: _parseInt(map['salesCount']),
      status: map['status']?.toString(),
      isActive: map['isActive'] as bool? ?? true,
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      quantity: parsedQuantity,
      images: normalizedImages,
      category: category,
      seller: seller,
      tags: map['tags'] is List
          ? (map['tags'] as List).map((e) => e.toString()).toList()
          : null,
      reviews: null,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'productId': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'rating': totalrate ?? 0,
      'stock': quantity,
      'images': images,
      'productImage': image,
      'sellerId': seller.email,
      'categoryId': category?.id,
      'tags': tags ?? <String>[],
      'isActive': isActive,
      'status': status ?? 'approved',
      'salesCount': salesCount ?? 0,
      'createdAt': createdAt ?? DateTime.now(),
      'updatedAt': updatedAt ?? DateTime.now(),
    };

    if (discountedPrice != null) {
      data['discountedPrice'] = discountedPrice;
    } else {
      data['discountedPrice'] = null;
    }

    return data;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);

    try {
      final parsed = value.toDate();
      if (parsed is DateTime) return parsed;
    } catch (_) {
      // Ignore unsupported types.
    }

    return null;
  }
}
