import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/service/firebase_order_service.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({FirebaseOrderService? orderService})
    : _orderService = orderService ?? FirebaseOrderService(),
      super(OrderInitial());

  final FirebaseOrderService _orderService;
  List<CustomerOrderModel> allordersList = [];
  List<CustomerOrderModel> displayedordersList = [];
  OrderStatus? selectedStatus;
  int orderID = 10050;

  void _syncDisplayedOrders(List<CustomerOrderModel> orders) {
    displayedordersList = orders;
  }

  Future<void> _refreshByCurrentFilter() async {
    if (selectedStatus == null) {
      allordersList = await _orderService.getAllOrders();
      _syncDisplayedOrders(allordersList);
      return;
    }

    final filtered = await _orderService.getFilteredOrders(selectedStatus!);
    _syncDisplayedOrders(filtered);
  }

  /*------------------------------------------- */
  Future<void> getAllOrders() async {
    selectedStatus = null;
    emit(GetAllOrdersLoadingState());
    try {
      allordersList = await _orderService.getAllOrders();
      _syncDisplayedOrders(allordersList);

      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      emit(GetAllOrdersFailedState(errorMessage: e.toString()));
    }
  } /*------------------------------------------- */

  Future<void> getFilteredOrders({required OrderStatus status}) async {
    selectedStatus = status;
    emit(GetFilteredOrdersLoadingState());
    try {
      final fetchedOrders = await _orderService.getFilteredOrders(status);
      _syncDisplayedOrders(fetchedOrders);
      emit(GetFilteredOrdersSuccessState(filteredorders: fetchedOrders));
    } catch (e) {
      emit(GetFilteredOrdersFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> getOrderDetails(String orderId) async {
    emit(GetOrderDetailsLoadingState());
    try {
      await _orderService.getOrderDetails(orderId);
      emit(GetOrderDetailsSuccessState());
    } catch (e) {
      emit(GetOrderDetailsFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> placeNewOrder(
    CustomerOrderModel newOrder,
    BuildContext context,
  ) async {
    emit(PlaceOrderLoadingState());
    try {
      final cartCubit = context.read<CartCubit>();
      await cartCubit.makePayment(newOrder.payment, context);
      await _orderService.placeOrder(newOrder);
      await _refreshByCurrentFilter();
      showSnack(title: "Success", message: "Order placed successfully.");
      emit(PlaceOrderSuccessState());
      await cartCubit.clearCart();
    } catch (e) {
      emit(PlaceOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> cancelOrder(String orderId) async {
    emit(CancelOrderLoadingState());
    try {
      await _orderService.cancelOrder(orderId);
      await _refreshByCurrentFilter();

      emit(CancelOrderSuccessState());
      if (selectedStatus == null) {
        emit(GetAllOrdersSuccessState(orders: displayedordersList));
      } else {
        emit(
          GetFilteredOrdersSuccessState(filteredorders: displayedordersList),
        );
      }
    } catch (e) {
      emit(CancelOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
}
