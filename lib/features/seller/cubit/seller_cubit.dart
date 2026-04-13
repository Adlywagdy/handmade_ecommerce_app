import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/seller_model.dart';
import '../models/data/seller_mock_data.dart';
import 'seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  SellerCubit() : super(const SellerInitial());

  // ─── Dashboard ───
  void loadDashboard() {
    emit(SellerLoaded(
      products: List.from(mockSellerProducts),
      orders: List.from(mockSellerOrders),
      stats: mockDashboardStats,
      activeOrderFilter: 'All',
      productSearchQuery: '',
    ));
  }

  // ─── Product Management ───
  void searchProducts(String query) {
    final current = state;
    if (current is SellerLoaded) {
      emit(current.copyWith(productSearchQuery: query));
    }
  }

  void toggleProductActive(String productId) {
    final current = state;
    if (current is SellerLoaded) {
      final updatedProducts = current.products.map((p) {
        if (p.id == productId) {
          return p.copyWith(isActive: !p.isActive);
        }
        return p;
      }).toList();
      emit(current.copyWith(products: updatedProducts));
    }
  }

  void deleteProduct(String productId) {
    final current = state;
    if (current is SellerLoaded) {
      final updatedProducts =
          current.products.where((p) => p.id != productId).toList();
      emit(current.copyWith(products: updatedProducts));
    }
  }

  void addProduct(SellerProductModel product) {
    final current = state;
    if (current is SellerLoaded) {
      final updatedProducts = [product, ...current.products];
      emit(current.copyWith(products: updatedProducts));
    }
  }

  void updateProduct(SellerProductModel product) {
    final current = state;
    if (current is SellerLoaded) {
      final updatedProducts = current.products.map((p) {
        if (p.id == product.id) return product;
        return p;
      }).toList();
      emit(current.copyWith(products: updatedProducts));
    }
  }

  // ─── Order Management ───
  void filterOrders(String filter) {
    final current = state;
    if (current is SellerLoaded) {
      emit(current.copyWith(activeOrderFilter: filter));
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final current = state;
    if (current is SellerLoaded) {
      final updatedOrders = current.orders.map((o) {
        if (o.orderId == orderId) {
          return o.copyWith(status: newStatus);
        }
        return o;
      }).toList();
      emit(current.copyWith(orders: updatedOrders));
    }
  }

  // ─── Filtered getters ───
  List<SellerProductModel> get filteredProducts {
    final current = state;
    if (current is SellerLoaded) {
      if (current.productSearchQuery.isEmpty) return current.products;
      return current.products
          .where((p) => p.name
              .toLowerCase()
              .contains(current.productSearchQuery.toLowerCase()))
          .toList();
    }
    return [];
  }

  List<SellerOrderModel> get filteredOrders {
    final current = state;
    if (current is SellerLoaded) {
      if (current.activeOrderFilter == 'All') return current.orders;
      return current.orders
          .where((o) => o.status == current.activeOrderFilter)
          .toList();
    }
    return [];
  }
}
