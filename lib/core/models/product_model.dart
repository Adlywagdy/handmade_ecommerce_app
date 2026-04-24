import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/models/reviews_model.dart';

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
  final List<ReviewsModel>? reviews;
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

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountedPrice,
    String? currency,
    double? totalrate,
    int? salesCount,
    String? status,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? quantity,
    List<ReviewsModel>? reviews,
    List<String>? images,
    List<String>? tags,
    SellerModel? seller,
    CategoryModel? category,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      currency: currency ?? this.currency,
      totalrate: totalrate ?? this.totalrate,
      salesCount: salesCount ?? this.salesCount,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quantity: quantity ?? this.quantity,
      reviews: reviews ?? this.reviews,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      seller: seller ?? this.seller,
      category: category ?? this.category,
    );
  }

  String? get image => images.isNotEmpty ? images.first : null;
  double get rating => totalrate ?? 0;
  String get sellerId => seller.primaryIdentifier;
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
    final sellerReferenceId =
        SellerModel.normalizeReferenceId(sellerMap) ??
        SellerModel.normalizeReferenceId(map['sellerId']);
    final sellerData = sellerMap is Map<String, dynamic>
        ? sellerMap
        : <String, dynamic>{
            'id': sellerReferenceId ?? map['sellerId'],
            'sellerId': sellerReferenceId ?? map['sellerId'],
            'name': map['sellerName'],
            'email': map['sellerEmail'] ?? sellerReferenceId ?? map['sellerId'],
            'specialty': map['sellerSpecialty'],
            'image': map['sellerImage'],
            'badge': map['sellerBadge'],
            'location': map['sellerLocation'],
          };
    final seller = SellerModel.fromMap(
      sellerData,
      fallbackId: (sellerReferenceId ?? map['sellerId'])?.toString(),
    );

    final categoryMap = map['category'];
    final categoryReferenceId =
        CategoryModel.normalizeReferenceId(categoryMap) ??
        CategoryModel.normalizeReferenceId(map['categoryId']);
    final category = categoryMap is Map<String, dynamic>
        ? CategoryModel.fromMap(categoryMap, id: categoryReferenceId)
        : (categoryReferenceId != null || map['categoryName'] != null)
        ? CategoryModel(
            id: categoryReferenceId,
            categorytitle:
                (map['categoryName'] ?? categoryReferenceId ?? 'General')
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
      'sellerId': sellerId,
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
