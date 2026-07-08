part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final List<ProductModel> products;
  CartSuccess({required this.products});
}

final class CartError extends CartState {
  final String message;
  CartError({required this.message});
}

final class AddProductLoading extends CartState {}

final class AddProductSuccess extends CartState {}

final class AddProductError extends CartState {
  final String message;
  AddProductError({required this.message});
}

final class DeleteProductLoading extends CartState {}

final class DeleteProductSuccess extends CartState {}

final class DeleteProductError extends CartState {
  final String message;
  DeleteProductError({required this.message});
}

final class OrderSummaryLoading extends CartState {}

final class OrderSummarySuccess extends CartState {
  final double subtotalPrice;
  final double totalPrice;
  final double deliveryFee;
  final double discount;
  OrderSummarySuccess({
    required this.subtotalPrice,
    required this.totalPrice,
    required this.deliveryFee,
    required this.discount,
  });
}

final class OrderSummaryError extends CartState {
  final String message;
  OrderSummaryError({required this.message});
}

final class OrderAddressLoading extends CartState {}

final class OrderAddressSuccess extends CartState {
  final AddressModel address;
  OrderAddressSuccess({required this.address});
}

final class OrderAddressError extends CartState {
  final String message;
  OrderAddressError({required this.message});
}
