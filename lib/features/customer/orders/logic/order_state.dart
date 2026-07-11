part of 'order_cubit.dart';

sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class GetAllOrdersLoading extends OrderState {}

final class GetAllOrdersSuccess extends OrderState {
  final List<CustomerOrderModel> orders;
  GetAllOrdersSuccess({required this.orders});
}

final class GetAllOrdersError extends OrderState {
  final String message;
  GetAllOrdersError({required this.message});
}

final class GetFilteredOrdersLoading extends OrderState {}

final class GetFilteredOrdersSuccess extends OrderState {
  final List<CustomerOrderModel> orders;
  GetFilteredOrdersSuccess({required this.orders});
}

final class GetFilteredOrdersError extends OrderState {
  final String message;
  GetFilteredOrdersError({required this.message});
}

final class PlaceOrderLoading extends OrderState {}

final class PlaceOrderSuccess extends OrderState {}

final class PlaceOrderError extends OrderState {
  final String message;
  PlaceOrderError({required this.message});
}

final class CancelOrderLoading extends OrderState {}

final class CancelOrderSuccess extends OrderState {}

final class CancelOrderError extends OrderState {
  final String message;
  CancelOrderError({required this.message});
}
