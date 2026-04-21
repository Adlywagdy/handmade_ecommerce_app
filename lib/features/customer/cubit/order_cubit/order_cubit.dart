import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';

import 'package:handmade_ecommerce_app/features/customer/models/data/test_orderslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  List<OrderModel> allordersList = [];
  List<OrderModel> filteredordersList = [];
  List<OrderModel> displayedordersList = [];
  OrderStatus? selectedStatus;
  String searchQuery = '';
  Timer? _searchDebounce;

  List<OrderModel> _applySearch(List<OrderModel> source, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return source;
    }

    return source.where((order) {
      return order.orderid.toLowerCase().contains(normalizedQuery) ||
          order.customer.name.toLowerCase().contains(normalizedQuery) ||
          order.customer.email.toLowerCase().contains(normalizedQuery) ||
          order.customer.phone.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  List<OrderModel> _ordersForActiveTab() {
    if (selectedStatus == null) {
      return allordersList;
    }

    return allordersList
        .where((order) => order.status == selectedStatus)
        .toList();
  }

  void _syncDisplayedOrders(List<OrderModel> orders) {
    displayedordersList = orders;
  }

  /*------------------------------------------- */
  Future<void> getAllOrders() async {
    selectedStatus = null;
    emit(GetAllOrdersLoadingState());
    try {
      // Simulate a delay for loading orders
      await Future.delayed(const Duration(seconds: 2));
      allordersList = ordersListdata; // Replace with actual data from Firestore
      _syncDisplayedOrders(_applySearch(allordersList, searchQuery));
      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      emit(GetAllOrdersFailedState(errorMessage: e.toString()));
    }
  } /*------------------------------------------- */

  Future<void> getFilteredOrders({required OrderStatus status}) async {
    selectedStatus = status;
    emit(GetFilteredOrdersLoadingState());
    try {
      // Simulate a delay for loading orders
      await Future.delayed(const Duration(seconds: 2), () {});
      filteredordersList = _applySearch(_ordersForActiveTab(), searchQuery);
      _syncDisplayedOrders(filteredordersList);
      emit(GetFilteredOrdersSuccessState(filteredorders: filteredordersList));
    } catch (e) {
      emit(GetFilteredOrdersFailedState(errorMessage: e.toString()));
    }
  }

  void searchOrders(String query) {
    searchQuery = query;

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      final source = _ordersForActiveTab();
      displayedordersList = _applySearch(source, searchQuery);
      if (selectedStatus != null) {
        filteredordersList = displayedordersList;
      }
      emit(SearchOrdersSuccessState(orders: displayedordersList));
    });
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  /*------------------------------------------- */
  Future<void> getOrderDetails(String orderId) async {
    emit(GetOrderDetailsLoadingState());
    try {
      // Simulate a delay for loading order details
      await Future.delayed(const Duration(seconds: 2));
      // Replace with actual logic to fetch order details from Firestore
      emit(GetOrderDetailsSuccessState());
    } catch (e) {
      emit(GetOrderDetailsFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> placeNewOrder(OrderModel newOrder, BuildContext context) async {
    emit(PlaceOrderLoadingState());
    try {
      final cartCubit = context.read<CartCubit>();
      await cartCubit.makePayment(newOrder.payment, context);
      allordersList.add(newOrder);
      emit(PlaceOrderSuccessState());
      cartCubit.clearCart();
    } catch (e) {
      emit(PlaceOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> cancelOrder(String orderId) async {
    emit(CancelOrderLoadingState());
    try {
      // Simulate a delay
      await Future.delayed(const Duration(seconds: 2), () {});
      allordersList.removeWhere((order) => order.orderid == orderId);
      filteredordersList.removeWhere((order) => order.orderid == orderId);
      displayedordersList.removeWhere((order) => order.orderid == orderId);
      emit(CancelOrderSuccessState());
      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      emit(CancelOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
}
