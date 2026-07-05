import 'package:handmade_ecommerce_app/core/utils/parse_utils.dart';

class SellerModel {
  final String? id;
  final String name;
  final String email;
  final String specialty;
  final String submittedDate;
  final String? ownerName;
  final String? phone;
  final String? badge;
  final String? image;
  final String? city;
  final String? country;
  final String? location;
  final double? rating;
  final int? totalProducts;
  final int? totalSales;
  final double? walletBalance;
  final double? commissionRate;
  final bool? isActive;
  final String? status;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final DateTime? createdAt;

  const SellerModel({
    this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.submittedDate,
    this.ownerName,
    this.phone,
    this.badge,
    this.image,
    this.city,
    this.country,
    this.location,
    this.rating,
    this.totalProducts,
    this.totalSales,
    this.walletBalance,
    this.commissionRate,
    this.isActive,
    this.status,
    this.submittedAt,
    this.approvedAt,
    this.createdAt,
  });

  factory SellerModel.fromMap(Map<String, dynamic> map, {String? fallbackId}) {
    final submittedAt = parseDateTime(map['submittedAt']);
    final approvedAt = parseDateTime(map['approvedAt']);
    final createdAt = parseDateTime(map['createdAt']);

    return SellerModel(
      id:
          cleanString(map['id']) ??
          cleanString(map['uid']) ??
          cleanString(map['sellerId']) ??
          cleanString(fallbackId),
      name:
          cleanString(map['name']) ??
          cleanString(map['ownerName']) ??
          cleanString(map['fullName']) ??
          '',
      email:
          cleanString(map['email']) ??
          cleanString(map['sellerEmail']) ??
          cleanString(map['uid']) ??
          cleanString(map['sellerId']) ??
          cleanString(fallbackId) ??
          '',
      specialty:
          cleanString(map['specialty']) ??
          cleanString(map['shopName']) ??
          cleanString(map['storeName']) ??
          '',
      submittedDate:
          cleanString(map['submittedDate']) ?? _formatDate(submittedAt),
      ownerName: cleanString(map['ownerName']),
      phone: cleanString(map['phone']),
      badge: cleanString(map['badge']),
      image:
          cleanString(map['avatar']) ??
          cleanString(map['profileImage']) ??
          cleanString(map['image']) ??
          cleanString(map['photoUrl']) ??
          cleanString(map['sellerImage']),
      city: cleanString(map['city']),
      country: cleanString(map['country']),
      location:
          composeLocation(
            city: cleanString(map['city']),
            country: cleanString(map['country']),
          ) ??
          cleanString(map['location']) ??
          cleanString(map['address']) ??
          cleanString(map['sellerLocation']),
      rating: parseDouble(map['rating']),
      totalProducts: parseInt(map['totalProducts']),
      totalSales: parseInt(map['totalSales']),
      walletBalance: parseDouble(map['walletBalance']),
      commissionRate: parseDouble(map['commissionRate']),
      isActive: map['isActive'] as bool?,
      status: cleanString(map['status']),
      submittedAt: submittedAt,
      approvedAt: approvedAt,
      createdAt: createdAt,
    );
  }

  SellerModel mergedWith(SellerModel fallback) {
    return SellerModel(
      id: cleanString(id) ?? cleanString(fallback.id),
      name: cleanString(name) ?? cleanString(fallback.name) ?? '',
      email: cleanString(email) ?? cleanString(fallback.email) ?? '',
      specialty: cleanString(specialty) ?? cleanString(fallback.specialty) ?? '',
      submittedDate:
          cleanString(submittedDate) ?? cleanString(fallback.submittedDate) ?? '',
      ownerName: cleanString(ownerName) ?? cleanString(fallback.ownerName),
      phone: cleanString(phone) ?? cleanString(fallback.phone),
      badge: cleanString(badge) ?? cleanString(fallback.badge),
      image: cleanString(image) ?? cleanString(fallback.image),
      city: cleanString(city) ?? cleanString(fallback.city),
      country: cleanString(country) ?? cleanString(fallback.country),
      location: cleanString(location) ?? cleanString(fallback.location),
      rating: rating ?? fallback.rating,
      totalProducts: totalProducts ?? fallback.totalProducts,
      totalSales: totalSales ?? fallback.totalSales,
      walletBalance: walletBalance ?? fallback.walletBalance,
      commissionRate: commissionRate ?? fallback.commissionRate,
      isActive: isActive ?? fallback.isActive,
      status: cleanString(status) ?? cleanString(fallback.status),
      submittedAt: submittedAt ?? fallback.submittedAt,
      approvedAt: approvedAt ?? fallback.approvedAt,
      createdAt: createdAt ?? fallback.createdAt,
    );
  }

  String get displayName => cleanString(name) ?? 'Unknown Seller';
  String get displayOwnerName => cleanString(ownerName) ?? 'Unknown owner';
  String get displayBadge => cleanString(badge) ?? 'Verified Seller';
  String get displayPhone => cleanString(phone) ?? 'N/A';
  String get displaySpecialty => cleanString(specialty) ?? 'Handmade Seller';
  String get displayLocation => cleanString(location) ?? 'Unknown location';
  String get displayStatus => cleanString(status) ?? 'Unknown';
  String get displaySubmittedDate =>
      cleanString(submittedDate) ?? 'Unknown date';
  String? get avatarUrl => cleanString(image);

  String get primaryIdentifier {
    final normalizedId = normalizeReferenceId(id);
    if (normalizedId != null) return normalizedId;

    final normalizedEmail = normalizeReferenceId(email);
    if (normalizedEmail != null) return normalizedEmail;

    return '';
  }

  static String? normalizeReferenceId(dynamic value) {
    final cleaned = cleanString(value);
    if (cleaned == null) return null;

    final sellersPath = RegExp(r'^/?sellers/([^/]+)$');
    final pathMatch = sellersPath.firstMatch(cleaned);
    if (pathMatch != null && pathMatch.groupCount >= 1) {
      return pathMatch.group(1);
    }

    final embeddedPath = RegExp(r'sellers/([^/\s)]+)');
    final embeddedMatch = embeddedPath.firstMatch(cleaned);
    if (embeddedMatch != null && embeddedMatch.groupCount >= 1) {
      return embeddedMatch.group(1);
    }

    return cleaned;
  }

  static String? composeLocation({String? city, String? country}) {
    final parts = [
      if (cleanString(city) != null) cleanString(city)!,
      if (cleanString(country) != null) cleanString(country)!,
    ];
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    const monthNames = [
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
    ];
    return '${monthNames[date.month]} ${date.day}, ${date.year}';
  }
}
