import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/orders_model.dart';
import '../models/products_model.dart';
import '../models/sellers_model.dart';
import '../models/settings_model.dart';
import '../services/admin_service.dart';
part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._service) : super(AdminInitial());

  final AdminFirestoreService _service;

  List<SellerData> sellersList = [];
  List<OrderModel> ordersList = [];
  List<ProductsModel> productsList = [];
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

  ////////////////////// Subscriptions /////////////////////
  StreamSubscription<List<SellerData>>? _sellersSub;
  StreamSubscription<List<OrderModel>>? _ordersSub;
  StreamSubscription<List<ProductsModel>>? _productsSub;
  StreamSubscription<SettingsModel>? _settingsSub;

  ////////////////////// init method  /////////////////////
  void init() {
    getSellers();
    getOrders();
    getProducts();
    getSettings();
    getDashboard();
  }

  //////////////////////////// get sellers //////////////////////
  void getSellers() {
    if (sellersList.isEmpty) emit(GetSellersLoading());
    _sellersSub?.cancel();
    _sellersSub = _service.streamSellers().listen(
      (sellers) {
        sellersList = sellers;
        sellersById = {for (final s in sellers) s.id: s};
        emit(GetSellersSuccess());
      },
      onError: (e) => emit(GetSellersError(e.toString())),
    );
  }

  //////////////////////////// get orders //////////////////////
  void getOrders() {
    if (ordersList.isEmpty) emit(GetOrdersLoading());
    _ordersSub?.cancel();
    _ordersSub = _service.streamOrders().listen(
      (orders) {
        ordersList = orders;
        emit(GetOrdersSuccess());
      },
      onError: (e) => emit(GetOrdersError(e.toString())),
    );
  }
  //////////////////////////// get products //////////////////////
  void getProducts() {
    if (productsList.isEmpty) emit(GetProductsLoading());
    _productsSub?.cancel();
    _productsSub = _service.streamProducts().listen(
      (products) {
        productsList = products;
        emit(GetProductsSuccess());
      },
      onError: (e) => emit(GetProductsError(e.toString())),
    );
  }

  void getSettings() {
    _settingsSub?.cancel();
    _settingsSub = _service.streamSettings().listen(
      (s) {
        settings = s;
        emit( GetSettingsSuccess());
      },
      onError: (e) => emit(GetSettingsError(e.toString())),
    );
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
  Future<void> approveSeller(String id) => _runUpdate(id, () => _service.approveSeller(id));
  Future<void> rejectSeller(String id) => _runUpdate(id, () => _service.rejectSeller(id));
  Future<void> approveProduct(String id) => _runUpdate(id, () => _service.approveProduct(id));
  Future<void> rejectProduct(String id) => _runUpdate(id, () => _service.rejectProduct(id));

  static const _terminalOrderStatuses = {
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  };

  Future<void> updateOrderStatus(OrderModel order, OrderStatus next) async {
    if (_terminalOrderStatuses.contains(order.status) && next.index < order.status.index) {
      emit(UpdateAdminFailure('Cannot roll back from ${order.status.name}'));
      return;
    }
    await _runUpdate(order.id, () => _service.updateOrderStatus(order.id, next));
  }

  Future<void> setCommissionRate(double rate) async {
    savingCommission = true;
    emit(UpdateAdminLoading());
    try {
      await _service.setCommissionRate(rate);
      savingCommission = false;
      emit(UpdateAdminSuccess());
    } catch (e) {
      savingCommission = false;
      emit(UpdateAdminError(e.toString()));
    }
  }

  Future<void> _runUpdate(String id, Future<void> Function() action) async {
    processingIds = {...processingIds, id};
    emit(UpdateAdminLoading());
    try {
      await action();
      processingIds = {...processingIds}..remove(id);
      emit(UpdateAdminSuccess());
    } catch (e) {
      processingIds = {...processingIds}..remove(id);
      emit(UpdateAdminError(e.toString()));
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

  ////////////////////////////  Helpers   ////////////////////////////
  bool isProcessing(String id) => processingIds.contains(id);

  String vendorNameFor(ProductsModel product) {
    final seller = sellersById[product.sellerId];
    if (seller != null && seller.name.isNotEmpty) return seller.name;
    final stored = product.vendorName;
    if (stored != null && stored.isNotEmpty && stored != 'null') return stored;
    return 'Unknown vendor';
  }

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

  List<SellerData> sellersByStatus(SellerStatus status) => _applySellerSearch(sellersList).where((s) => s.status == status).toList();

  List<SellerData> _applySellerSearch(List<SellerData> list) {
    if (sellersQuery.isEmpty) return list;
    final q = sellersQuery.toLowerCase();
    return list.where((s) => s.name.toLowerCase().contains(q) || s.email.toLowerCase().contains(q) || s.specialty.toLowerCase().contains(q)).toList();
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
        return filtered.where((o) => o.status == OrderStatus.pending).toList();
      case 2:
        return filtered.where((o) => _activeOrderStatuses.contains(o.status)).toList();
      case 3:
        return filtered.where((o) => o.status == OrderStatus.delivered).toList();
      case 4:
        return filtered.where((o) => o.status == OrderStatus.cancelled).toList();
      default:
        return filtered;
    }
  }

  List<OrderModel> _applyOrderSearch(List<OrderModel> list) {
    if (ordersQuery.isEmpty) return list;
    final q = ordersQuery.toLowerCase();
    return list.where((o) {
      final customer = o.customerName ?? '';
      final seller = o.sellerName ?? '';
      return o.displayId.toLowerCase().contains(q) || customer.toLowerCase().contains(q) || seller.toLowerCase().contains(q);
    }).toList();
  }

  List<ProductsModel> productsByStatus(String status) => _applyProductSearch(productsList).where((p) => p.status == status).toList();

  List<ProductsModel> _applyProductSearch(List<ProductsModel> list) {
    if (productsQuery.isEmpty) return list;
    final q = productsQuery.toLowerCase();
    return list.where((p) {
      final vendor = vendorNameFor(p).toLowerCase();
      return p.name.toLowerCase().contains(q) || vendor.contains(q);
    }).toList();
  }

  /// Allowed next-status transitions for a given order status.
  /// Returns empty list for terminal statuses (delivered, cancelled).
  List<(OrderStatus, String)> nextOrderActions(OrderStatus current) {
    switch (current) {
      case OrderStatus.pending:
        return [
          (OrderStatus.confirmed, 'Confirm'),
          (OrderStatus.cancelled, 'Cancel'),
        ];
      case OrderStatus.confirmed:
        return [
          (OrderStatus.preparing, 'Prepare'),
          (OrderStatus.cancelled, 'Cancel'),
        ];
      case OrderStatus.preparing:
        return [
          (OrderStatus.shipped, 'Ship'),
          (OrderStatus.cancelled, 'Cancel'),
        ];
      case OrderStatus.shipped:
        return [(OrderStatus.delivered, 'Deliver')];
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
        return [];
    }
  }

  @override
  Future<void> close() {
    _sellersSub?.cancel();
    _ordersSub?.cancel();
    _productsSub?.cancel();
    _settingsSub?.cancel();
    return super.close();
  }
}
