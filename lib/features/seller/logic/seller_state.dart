<<<<<<< HEAD:lib/features/seller/logic/seller_state.dart
import '../data/models/seller_model.dart';
=======
import '../models/seller_model.dart';
import '../../../../core/models/category_model.dart';
>>>>>>> b3f706d1c93438364cf27aeaeb668eae6afdaa7a:lib/features/seller/cubit/seller_state.dart

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
  final List<CategoryModel> categories;
  final SellerDashboardStats stats;
  final String activeOrderFilter;
  final String productSearchQuery;

  const SellerLoaded({
    required this.products,
    required this.orders,
    required this.categories,
    required this.stats,
    required this.activeOrderFilter,
    required this.productSearchQuery,
  });

  SellerLoaded copyWith({
    List<SellerProductModel>? products,
    List<SellerOrderModel>? orders,
    List<CategoryModel>? categories,
    SellerDashboardStats? stats,
    String? activeOrderFilter,
    String? productSearchQuery,
  }) {
    return SellerLoaded(
      products: products ?? this.products,
      orders: orders ?? this.orders,
      categories: categories ?? this.categories,
      stats: stats ?? this.stats,
      activeOrderFilter: activeOrderFilter ?? this.activeOrderFilter,
      productSearchQuery: productSearchQuery ?? this.productSearchQuery,
    );
  }
}
