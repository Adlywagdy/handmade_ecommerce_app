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
    final submittedAt = _parseDateTime(map['submittedAt']);
    final approvedAt = _parseDateTime(map['approvedAt']);
    final createdAt = _parseDateTime(map['createdAt']);

    return SellerModel(
      id:
          _cleanString(map['id']) ??
          _cleanString(map['uid']) ??
          _cleanString(map['sellerId']) ??
          _cleanString(fallbackId),
      name:
          _cleanString(map['name']) ??
          _cleanString(map['ownerName']) ??
          _cleanString(map['fullName']) ??
          '',
      email:
          _cleanString(map['email']) ??
          _cleanString(map['sellerEmail']) ??
          _cleanString(map['uid']) ??
          _cleanString(map['sellerId']) ??
          _cleanString(fallbackId) ??
          '',
      specialty:
          _cleanString(map['specialty']) ??
          _cleanString(map['shopName']) ??
          _cleanString(map['storeName']) ??
          '',
      submittedDate:
          _cleanString(map['submittedDate']) ?? _formatDate(submittedAt),
      ownerName: _cleanString(map['ownerName']),
      phone: _cleanString(map['phone']),
      badge: _cleanString(map['badge']),
      image:
          _cleanString(map['avatar']) ??
          _cleanString(map['profileImage']) ??
          _cleanString(map['image']) ??
          _cleanString(map['photoUrl']) ??
          _cleanString(map['sellerImage']),
      city: _cleanString(map['city']),
      country: _cleanString(map['country']),
      location:
          _composeLocation(
            city: _cleanString(map['city']),
            country: _cleanString(map['country']),
          ) ??
          _cleanString(map['location']) ??
          _cleanString(map['address']) ??
          _cleanString(map['sellerLocation']),
      rating: _parseDouble(map['rating']),
      totalProducts: _parseInt(map['totalProducts']),
      totalSales: _parseInt(map['totalSales']),
      walletBalance: _parseDouble(map['walletBalance']),
      commissionRate: _parseDouble(map['commissionRate']),
      isActive: map['isActive'] as bool?,
      status: _cleanString(map['status']),
      submittedAt: submittedAt,
      approvedAt: approvedAt,
      createdAt: createdAt,
    );
  }

  SellerModel mergedWith(SellerModel fallback) {
    return SellerModel(
      id: _firstNonEmpty(id, fallback.id),
      name: _firstNonEmpty(name, fallback.name) ?? '',
      email: _firstNonEmpty(email, fallback.email) ?? '',
      specialty: _firstNonEmpty(specialty, fallback.specialty) ?? '',
      submittedDate:
          _firstNonEmpty(submittedDate, fallback.submittedDate) ?? '',
      ownerName: _firstNonEmpty(ownerName, fallback.ownerName),
      phone: _firstNonEmpty(phone, fallback.phone),
      badge: _firstNonEmpty(badge, fallback.badge),
      image: _firstNonEmpty(image, fallback.image),
      city: _firstNonEmpty(city, fallback.city),
      country: _firstNonEmpty(country, fallback.country),
      location: _firstNonEmpty(location, fallback.location),
      rating: rating ?? fallback.rating,
      totalProducts: totalProducts ?? fallback.totalProducts,
      totalSales: totalSales ?? fallback.totalSales,
      walletBalance: walletBalance ?? fallback.walletBalance,
      commissionRate: commissionRate ?? fallback.commissionRate,
      isActive: isActive ?? fallback.isActive,
      status: _firstNonEmpty(status, fallback.status),
      submittedAt: submittedAt ?? fallback.submittedAt,
      approvedAt: approvedAt ?? fallback.approvedAt,
      createdAt: createdAt ?? fallback.createdAt,
    );
  }

  String get displayName => _defaultIfEmpty(name, 'Unknown Seller');
  String get displayOwnerName => _defaultIfEmpty(ownerName, 'Unknown owner');
  String get displayBadge => _defaultIfEmpty(badge, 'Verified Seller');
  String get displayPhone => _defaultIfEmpty(phone, 'N/A');
  String get displaySpecialty => _defaultIfEmpty(specialty, 'Handmade Seller');
  String get displayLocation => _defaultIfEmpty(location, 'Unknown location');
  String get displayStatus => _defaultIfEmpty(status, 'Unknown');
  String get displaySubmittedDate =>
      _defaultIfEmpty(submittedDate, 'Unknown date');
  String? get avatarUrl => _cleanString(image);

  String get primaryIdentifier {
    final normalizedId = normalizeReferenceId(id);
    if (normalizedId != null) return normalizedId;

    final normalizedEmail = normalizeReferenceId(email);
    if (normalizedEmail != null) return normalizedEmail;

    return '';
  }

  static String? normalizeReferenceId(dynamic value) {
    final cleaned = _cleanString(value);
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

  static String _defaultIfEmpty(String? value, String fallback) {
    final normalized = _cleanString(value);
    return normalized ?? fallback;
  }

  static String? _composeLocation({String? city, String? country}) {
    final parts = [
      if (_cleanString(city) != null) _cleanString(city)!,
      if (_cleanString(country) != null) _cleanString(country)!,
    ];
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  static String? _firstNonEmpty(String? primary, String? fallback) {
    return _cleanString(primary) ?? _cleanString(fallback);
  }

  static String? _cleanString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return text;
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
      // Ignore unsupported date representations.
    }

    return null;
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
