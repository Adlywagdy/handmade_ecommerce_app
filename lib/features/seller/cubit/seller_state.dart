import '../models/seller_model.dart';

abstract class SellerState {
  const SellerState();
}

class SellerInitial extends SellerState {
  const SellerInitial();
}

class SellerLoading extends SellerState {
  const SellerLoading();
}

class SellerError extends SellerState {
  final String message;
  const SellerError(this.message);
}

class SellerLoaded extends SellerState {
  final List<SellerProductModel> products;
  final List<SellerOrderModel> orders;
  final SellerDashboardStats stats;
  final String activeOrderFilter;
  final String productSearchQuery;

  const SellerLoaded({
    required this.products,
    required this.orders,
    required this.stats,
    required this.activeOrderFilter,
    required this.productSearchQuery,
  });

  SellerLoaded copyWith({
    List<SellerProductModel>? products,
    List<SellerOrderModel>? orders,
    SellerDashboardStats? stats,
    String? activeOrderFilter,
    String? productSearchQuery,
  }) {
    return SellerLoaded(
      products: products ?? this.products,
      orders: orders ?? this.orders,
      stats: stats ?? this.stats,
      activeOrderFilter: activeOrderFilter ?? this.activeOrderFilter,
      productSearchQuery: productSearchQuery ?? this.productSearchQuery,
    );
  }
}
