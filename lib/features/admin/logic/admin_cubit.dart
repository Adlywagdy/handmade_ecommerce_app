import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/services/cloudinary_service.dart';
import '../data/models/category_model.dart';
import '../data/models/next_status_action.dart';
import '../data/models/orders_model.dart';
import '../data/models/products_model.dart';
import '../data/models/sellers_model.dart';
import '../data/models/settings_model.dart';
import '../data/services/admin_service.dart';
part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._service, {CloudinaryService? cloudinaryService})
    : _cloudinaryService = cloudinaryService ?? CloudinaryService(),
      super(AdminInitial());

  final AdminFirestoreService _service;
  final CloudinaryService _cloudinaryService;

  List<SellerData> sellersList = [];
  List<OrderModel> ordersList = [];
  List<ProductsModel> productsList = [];
  List<CategoryModel> categoriesList = [];
  Map<String, SellerData> sellersById = {};
  SettingsModel settings = const SettingsModel();
  AdminStats? dashboardStats;
  int pendingSellersCount = 0;
  int pendingProductsCount = 0;

  ///////////////////// Per-action tracking /////////////////////
  Set<String> processingIds = {};
  bool savingCommission = false;

  ///////////////////// Search queries /////////////////////
  String sellersQuery = '';
  String ordersQuery = '';
  String productsQuery = '';
  String categoriesQuery = '';

  ////////////////////// Subscriptions /////////////////////
  StreamSubscription<List<SellerData>>? _sellersSub;
  StreamSubscription<List<OrderModel>>? _ordersSub;
  StreamSubscription<List<ProductsModel>>? _productsSub;
  StreamSubscription<SettingsModel>? _settingsSub;
  StreamSubscription<List<CategoryModel>>? _categoriesSub;

  ////////////////////// init method  /////////////////////
  void init() {
    getSellers();
    getOrders();
    getProducts();
    getSettings();
    getCategories();
    getDashboard();
  }

  //////////////////////////// get sellers //////////////////////

  void getSellers() {
    if (sellersList.isEmpty) emit(GetSellersLoading());
    _sellersSub?.cancel();
    _sellersSub = _service.streamSellers().listen((sellers) {
      sellersList = sellers;
      for (var seller in sellers) {
        sellersById[seller.id] = seller;
      }
      emit(GetSellersSuccess());
    }, onError: (error) => emit(GetSellersError(error.toString())));
  }

  //////////////////////////// get orders //////////////////////
  void getOrders() {
    if (ordersList.isEmpty) emit(GetOrdersLoading());
    _ordersSub?.cancel();
    _ordersSub = _service.streamOrders().listen((orders) {
      ordersList = orders;
      emit(GetOrdersSuccess());
    }, onError: (error) => emit(GetOrdersError(error.toString())));
  }

  //////////////////////////// get products //////////////////////
  void getProducts() {
    if (productsList.isEmpty) emit(GetProductsLoading());
    _productsSub?.cancel();
    _productsSub = _service.streamProducts().listen((products) {
      productsList = products;
      emit(GetProductsSuccess());
    }, onError: (error) => emit(GetProductsError(error.toString())));
  }

  void getSettings() {
    _settingsSub?.cancel();
    _settingsSub = _service.streamSettings().listen((settingsData) {
      settings = settingsData;
      emit(GetSettingsSuccess());
    }, onError: (error) => emit(GetSettingsError(error.toString())));
  }

  void getCategories() {
    if (categoriesList.isEmpty) emit(GetCategoriesLoading());
    _categoriesSub?.cancel();
    _categoriesSub = _service.streamCategories().listen((categories) {
      categoriesList = categories;
      emit(GetCategoriesSuccess());
    }, onError: (error) => emit(GetCategoriesError(error.toString())));
  }

  Future<void> getDashboard() async {
    if (dashboardStats == null) emit(GetDashboardDataLoading());
    try {
      final results = await Future.wait([
        _service.fetchStats(),
        _service.fetchPendingSellersCount(),
        _service.fetchPendingProductsCount(),
      ]);
      dashboardStats = results[0] as AdminStats;
      pendingSellersCount = results[1] as int;
      pendingProductsCount = results[2] as int;
      emit(GetDashboardDataSuccess());
    } catch (e) {
      emit(GetDashboardDataError(e.toString()));
    }
  }

  Future<void> refreshDashboard() => getDashboard();

  //////////////////////////// Updates   ////////////////////////////
  Future<void> approveSeller(String id) =>
      _runUpdate(id, () => _service.approveSeller(id));
  Future<void> rejectSeller(String id) =>
      _runUpdate(id, () => _service.rejectSeller(id));
  Future<void> approveProduct(String id) =>
      _runUpdate(id, () => _service.approveProduct(id));
  Future<void> rejectProduct(String id) =>
      _runUpdate(id, () => _service.rejectProduct(id));

  static const _terminalOrderStatuses = {
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  };

  Future<void> updateOrderStatus(OrderModel order, OrderStatus next) async {
    if (_terminalOrderStatuses.contains(order.status) &&
        next.index < order.status.index) {
      emit(UpdateSettingsFailure('Cannot roll back from ${order.status.name}'));
      return;
    }
    await _runUpdate(
      order.id,
      () => _service.updateOrderStatus(order.id, next),
    );
  }

  Future<void> setCommissionRate(double rate) async {
    savingCommission = true;
    emit(UpdateSettingsLoading());
    try {
      await _service.setCommissionRate(rate);
      savingCommission = false;
      emit(UpdateSettingsSuccess());
    } catch (e) {
      savingCommission = false;
      emit(UpdateSettingsError(e.toString()));
    }
  }

  Future<void> _runUpdate(String id, Future<void> Function() action) async {
    processingIds = {...processingIds, id};
    emit(UpdateSettingsLoading());
    try {
      await action();
      emit(UpdateSettingsSuccess());
    } catch (e) {
      emit(UpdateSettingsError(e.toString()));
    } finally {
      processingIds = {...processingIds}..remove(id);
    }
  }

  //////////////////////////// Category CRUD   ////////////////////////////
  Future<void> addCategory({
    required String nameEN,
    required String nameAR,
    required File imageFile,
    int order = 0,
  }) async {
    emit(CategoryActionLoading());
    try {
      final iconUrl = await _cloudinaryService.uploadImage(imageFile);
      final category = CategoryModel(
        nameEN: nameEN,
        nameAR: nameAR,
        icon: iconUrl,
        order: order,
        isActive: true,
      );
      await _service.addCategory(category);
      emit(CategoryActionSuccess('Category added successfully'));
    } catch (e) {
      emit(CategoryActionError(e.toString()));
    }
  }

  Future<void> updateCategory({
    required String id,
    required String nameEN,
    required String nameAR,
    File? imageFile,
    int? order,
    bool? isActive,
  }) async {
    emit(CategoryActionLoading());
    try {
      final data = <String, dynamic>{};
      data['nameEN'] = nameEN;
      data['nameAR'] = nameAR;
      if (imageFile != null) {
        data['icon'] = await _cloudinaryService.uploadImage(imageFile);
      }
      if (order != null) data['order'] = order;
      if (isActive != null) data['isActive'] = isActive;
      await _service.updateCategory(id, data);
      emit(CategoryActionSuccess('Category updated successfully'));
    } catch (e) {
      emit(CategoryActionError(e.toString()));
    }
  }

  Future<void> deleteCategory(String id) async {
    emit(CategoryActionLoading());
    try {
      await _service.deleteCategory(id);
      emit(CategoryActionSuccess('Category deleted successfully'));
    } catch (e) {
      emit(CategoryActionError(e.toString()));
    }
  }

  Future<void> toggleCategoryActive(String id, bool isActive) async {
    try {
      await _service.toggleCategoryActive(id, isActive);
    } catch (e) {
      emit(CategoryActionError(e.toString()));
    }
  }

  ////////////////////////////  Search setters  ////////////////////////////
  void setSellersQuery(String query) {
    sellersQuery = query;
    emit(GetSellersSuccess());
  }

  void setOrdersQuery(String query) {
    ordersQuery = query;
    emit(GetOrdersSuccess());
  }

  void setProductsQuery(String query) {
    productsQuery = query;
    emit(GetProductsSuccess());
  }

  void setCategoriesQuery(String query) {
    categoriesQuery = query;
    emit(GetCategoriesSuccess());
  }

  ////////////////////////////  Helpers   ////////////////////////////
  bool isProcessing(String id) => processingIds.contains(id);

  String vendorNameFor(ProductsModel product) {
    final seller = sellersById[product.sellerId];
    if (seller != null && seller.name.isNotEmpty) return seller.name;
    final stored = product.vendorName;
    if (stored != null && stored.isNotEmpty && stored != 'null') return stored;
    return 'Unknown vendor';
  }

  // get specific seller
  SellerData? sellerById(String id) => sellersById[id];

  ProductsModel? productById(String id) {
    for (final product in productsList) {
      if (product.id == id) return product;
    }
    return null;
  }

  OrderModel? orderById(String id) {
    for (final order in ordersList) {
      if (order.id == id) return order;
    }
    return null;
  }

  List<SellerData> sellersByStatus(SellerStatus status) =>
      _sellerSearch(sellersList).where((s) => s.status == status).toList();

  List<SellerData> _sellerSearch(List<SellerData> list) {
    if (sellersQuery.isEmpty) return list;
    final query = sellersQuery.toLowerCase();
    return list
        .where(
          (seller) =>
              seller.name.toLowerCase().contains(query) ||
              seller.email.toLowerCase().contains(query) ||
              seller.specialty.toLowerCase().contains(query),
        )
        .toList();
  }

  static const _activeOrderStatuses = {
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.shipped,
  };

  List<OrderModel> ordersByTab(int tab) {
    final filtered = _applyOrderSearch(ordersList);
    switch (tab) {
      case 0:
        return filtered;
      case 1:
        return filtered
            .where((order) => order.status == OrderStatus.pending)
            .toList();
      case 2:
        return filtered
            .where((order) => _activeOrderStatuses.contains(order.status))
            .toList();
      case 3:
        return filtered
            .where((order) => order.status == OrderStatus.delivered)
            .toList();
      case 4:
        return filtered
            .where((order) => order.status == OrderStatus.cancelled)
            .toList();
      default:
        return filtered;
    }
  }

  List<OrderModel> _applyOrderSearch(List<OrderModel> list) {
    if (ordersQuery.isEmpty) return list;
    final q = ordersQuery.toLowerCase();
    return list.where((order) {
      final customer = order.customerName ?? '';
      final seller = order.sellerName ?? '';
      return order.displayId.toLowerCase().contains(q) ||
          customer.toLowerCase().contains(q) ||
          seller.toLowerCase().contains(q);
    }).toList();
  }

  List<ProductsModel> productsByStatus(String status) => _applyProductSearch(
    productsList,
  ).where((p) => p.status == status).toList();

  List<ProductsModel> _applyProductSearch(List<ProductsModel> list) {
    if (productsQuery.isEmpty) return list;
    final q = productsQuery.toLowerCase();
    return list.where((product) {
      final vendor = vendorNameFor(product).toLowerCase();
      return product.name.toLowerCase().contains(q) || vendor.contains(q);
    }).toList();
  }

  List<CategoryModel> categoriesByActive({required bool active}) =>
      _applyCategorySearch(
        categoriesList,
      ).where((c) => c.isActive == active).toList();

  List<CategoryModel> _applyCategorySearch(List<CategoryModel> list) {
    if (categoriesQuery.isEmpty) return list;
    final q = categoriesQuery.toLowerCase();
    return list
        .where(
          (c) =>
              c.nameEN.toLowerCase().contains(q) ||
              c.nameAR.toLowerCase().contains(q),
        )
        .toList();
  }

  // Handle next-status transitions for order status.
  List<NextStatusAction> nextOrderActions(OrderStatus current) {
    switch (current) {
      case OrderStatus.pending:
        return const [
          NextStatusAction(status: OrderStatus.confirmed, label: 'Confirm'),
          NextStatusAction(status: OrderStatus.cancelled, label: 'Cancel'),
        ];
      case OrderStatus.confirmed:
        return const [
          NextStatusAction(status: OrderStatus.preparing, label: 'Prepare'),
          NextStatusAction(status: OrderStatus.cancelled, label: 'Cancel'),
        ];
      case OrderStatus.preparing:
        return const [
          NextStatusAction(status: OrderStatus.shipped, label: 'Ship'),
          NextStatusAction(status: OrderStatus.cancelled, label: 'Cancel'),
        ];
      case OrderStatus.shipped:
        return const [
          NextStatusAction(status: OrderStatus.delivered, label: 'Deliver'),
        ];
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
        return const [];
    }
  }

  @override
  Future<void> close() {
    _sellersSub?.cancel();
    _ordersSub?.cancel();
    _productsSub?.cancel();
    _settingsSub?.cancel();
    _categoriesSub?.cancel();
    return super.close();
  }
}
