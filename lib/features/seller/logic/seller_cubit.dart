import 'dart:io';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/services/cloudinary_service.dart';
<<<<<<< HEAD:lib/features/seller/logic/seller_cubit.dart
import '../data/models/seller_model.dart';
import '../data/services/seller_firestore_service.dart';
=======
import '../../../../core/models/category_model.dart';
import '../models/seller_model.dart';
import '../services/seller_firestore_service.dart';
>>>>>>> b3f706d1c93438364cf27aeaeb668eae6afdaa7a:lib/features/seller/cubit/seller_cubit.dart
import 'seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  final SellerFirestoreService _firestoreService;
  final CloudinaryService _cloudinaryService;

  StreamSubscription? _productsSubscription;
  StreamSubscription? _ordersSubscription;

  List<SellerProductModel> _currentProducts = [];
  List<SellerOrderModel> _currentOrders = [];
  List<CategoryModel> _currentCategories = [];
  bool _isListening = false;
  String? _lastSellerId;

  SellerCubit(this._firestoreService, {CloudinaryService? cloudinaryService})
    : _cloudinaryService = cloudinaryService ?? CloudinaryService(),
      super(const SellerInitial());

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    _ordersSubscription?.cancel();
    return super.close();
  }

  // ─── Dashboard ───
  Future<void> loadDashboard({bool showLoading = true}) async {
    try {
      final currentId = _firestoreService.currentSellerId;
      if (_lastSellerId != currentId) {
        _isListening = false; // Reset if user changed
        _lastSellerId = currentId;
      }
    } catch (_) {
      // currentSellerId throws if not authenticated, which shouldn't happen here, but just in case
    }

    if (_isListening) return; // Only initialize listeners once
    _isListening = true;

    if (showLoading) emit(const SellerLoading());

    try {
      _currentCategories = await _firestoreService.getCategories();
    } catch (_) {
      // If fetching categories fails, keep going with an empty list
      _currentCategories = [];
    }

    _productsSubscription?.cancel();
    _ordersSubscription?.cancel();

    _productsSubscription = _firestoreService.getProductsStream().listen(
      (products) async {
        _currentProducts = products;
        await _updateStateFromStreams();
      },
      onError: (e) {
        emit(SellerError(e.toString()));
      },
    );

    _ordersSubscription = _firestoreService.getOrdersStream().listen(
      (orders) async {
        _currentOrders = orders;
        await _updateStateFromStreams();
      },
      onError: (e) {
        emit(SellerError(e.toString()));
      },
    );
  }

  Future<void> _updateStateFromStreams() async {
    final current = state;
    String currentFilter = 'All';
    String currentQuery = '';

    if (current is SellerLoaded) {
      currentFilter = current.activeOrderFilter;
      currentQuery = current.productSearchQuery;
    }

    try {
      final stats = await _firestoreService.getDashboardStats(
        _currentOrders,
        productCount: _currentProducts.length,
      );

<<<<<<< HEAD:lib/features/seller/logic/seller_cubit.dart
      emit(
        SellerLoaded(
          products: _currentProducts,
          orders: _currentOrders,
          stats: stats,
          activeOrderFilter: currentFilter,
          productSearchQuery: currentQuery,
        ),
      );
=======
      emit(SellerLoaded(
        products: _currentProducts,
        orders: _currentOrders,
        categories: _currentCategories,
        stats: stats,
        activeOrderFilter: currentFilter,
        productSearchQuery: currentQuery,
      ));
>>>>>>> b3f706d1c93438364cf27aeaeb668eae6afdaa7a:lib/features/seller/cubit/seller_cubit.dart
    } catch (e) {
      emit(SellerError(e.toString()));
    }
  }

  // ─── Product Management ───
  void searchProducts(String query) {
    final current = state;
    if (current is SellerLoaded) {
      emit(current.copyWith(productSearchQuery: query));
    }
  }

  Future<void> toggleProductActive(String productId) async {
    final current = state;
    if (current is SellerLoaded) {
      final originalProducts = current.products;
      try {
        final product = current.products.firstWhere((p) => p.id == productId);
        final updatedProduct = product.copyWith(isActive: !product.isActive);

        // Optimistic UI update
        _updateProductsInState(current, updatedProduct);

        // Update in Firestore
        await _firestoreService.updateProduct(updatedProduct);
      } catch (e) {
        // Revert optimistic update
        emit(current.copyWith(products: originalProducts));
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    final current = state;
    if (current is SellerLoaded) {
      final originalProducts = current.products;
      try {
        // Optimistic UI update
        final updatedProducts = current.products
            .where((p) => p.id != productId)
            .toList();
        emit(current.copyWith(products: updatedProducts));

        // Update in Firestore
        await _firestoreService.deleteProduct(productId);
      } catch (e) {
        // Revert optimistic update
        emit(current.copyWith(products: originalProducts));
        rethrow;
      }
    }
  }

  Future<void> addProduct(SellerProductModel product) async {
    final current = state;
    if (current is SellerLoaded) {
      try {
        await _firestoreService.addProduct(product);
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> addProductWithImages({
    required String name,
    required String nameAR,
    required String description,
    required String descriptionAR,
    required double price,
    required int stock,
    required String categoryId,
    required List<File> imageFiles,
  }) async {
    final current = state;
    if (current is SellerLoaded) {
      try {
        emit(const SellerLoading());

        List<String> imageUrls = [];
        if (imageFiles.isNotEmpty) {
          imageUrls = await _cloudinaryService.uploadImages(imageFiles);
        }

        final newProduct = SellerProductModel(
          id: '',
          name: name,
          nameAR: nameAR,
          description: description,
          descriptionAR: descriptionAR,
          price: price,
          stock: stock,
          categoryId: categoryId,
          images: imageUrls,
          isActive: true,
          status: 'pending',
        );

        await _firestoreService.addProduct(newProduct);
        
        // Return to loaded state after successful addition
        await _updateStateFromStreams();
      } catch (e) {
        try {
          final testProduct = SellerProductModel(
            id: '',
            name: name,
            nameAR: nameAR,
            description: description,
            descriptionAR: descriptionAR,
            price: price,
            stock: stock,
            categoryId: categoryId,
            images: ['https://via.placeholder.com/400'],
            isActive: true,
            status: 'pending',
          );

          await _firestoreService.addProduct(testProduct);
          
          await _updateStateFromStreams();
        } catch (fallbackError) {
          await _updateStateFromStreams();
          rethrow;
        }
      }
    }
  }

  Future<void> updateProduct(SellerProductModel product) async {
    final current = state;
    if (current is SellerLoaded) {
      final originalProducts = current.products;
      try {
        // Optimistic UI update
        _updateProductsInState(current, product);

        // Update in Firestore
        await _firestoreService.updateProduct(product);
      } catch (e) {
        // Revert optimistic update
        emit(current.copyWith(products: originalProducts));
        rethrow;
      }
    }
  }

  Future<void> updateProductWithImages({
    required SellerProductModel product,
    required List<File> newImageFiles,
    required List<String> existingImageUrls,
  }) async {
    final current = state;
    if (current is SellerLoaded) {
      final originalProducts = current.products;
      try {
        emit(const SellerLoading());

        List<String> allImageUrls = List<String>.from(existingImageUrls);
        if (newImageFiles.isNotEmpty) {
          final uploadedUrls = await _cloudinaryService.uploadImages(
            newImageFiles,
          );
          allImageUrls = [...allImageUrls, ...uploadedUrls];
        }

        final updatedProduct = product.copyWith(
          images: allImageUrls.isNotEmpty
              ? allImageUrls
              : ['https://via.placeholder.com/150'],
        );

        _updateProductsInState(current, updatedProduct);
        await _firestoreService.updateProduct(updatedProduct);
      } catch (e) {
        emit(current.copyWith(products: originalProducts));
        rethrow;
      }
    }
  }

  void _updateProductsInState(
    SellerLoaded current,
    SellerProductModel updatedProduct,
  ) {
    final updatedProducts = current.products.map((p) {
      if (p.id == updatedProduct.id) return updatedProduct;
      return p;
    }).toList();
    emit(current.copyWith(products: updatedProducts));
  }

  // ─── Order Management ───
  void filterOrders(String filter) {
    final current = state;
    if (current is SellerLoaded) {
      emit(current.copyWith(activeOrderFilter: filter));
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final current = state;
    if (current is SellerLoaded) {
      final originalOrders = current.orders;
      try {
        // Optimistic UI update
        final updatedOrders = current.orders.map((o) {
          if (o.orderId == orderId) {
            return o.copyWith(status: newStatus);
          }
          return o;
        }).toList();
        emit(current.copyWith(orders: updatedOrders));

        // Update in Firestore
        await _firestoreService.updateOrderStatus(orderId, newStatus);
      } catch (e) {
        // Revert optimistic update
        emit(current.copyWith(orders: originalOrders));
        rethrow;
      }
    }
  }

  Future<void> archiveOrder(String orderId) async {
    final current = state;
    if (current is SellerLoaded) {
      final originalOrders = current.orders;
      try {
        // Optimistic UI update — remove from list
        final updatedOrders = current.orders
            .where((o) => o.orderId != orderId)
            .toList();
        emit(current.copyWith(orders: updatedOrders));

        // Archive in Firestore
        await _firestoreService.archiveOrder(orderId);
      } catch (e) {
        // Revert optimistic update
        emit(current.copyWith(orders: originalOrders));
        rethrow;
      }
    }
  }

  // ─── Filtered getters ───
  List<SellerProductModel> get filteredProducts {
    final current = state;
    if (current is SellerLoaded) {
      if (current.productSearchQuery.isEmpty) return current.products;
      return current.products
          .where(
            (p) => p.name.toLowerCase().contains(
              current.productSearchQuery.toLowerCase(),
            ),
          )
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
