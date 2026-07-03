part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

/* ------------------------------------------- */

final class GetcartLoadingstate extends CartState {}

final class GetcartSuccessedstate extends CartState {
  final List<ProductModel> cartproducts;

  GetcartSuccessedstate({required this.cartproducts});
}

final class GetcartFailedstate extends CartState {
  final String errorMessage;

  GetcartFailedstate({required this.errorMessage});
}
/* ------------------------------------------- */

final class AddcartproductLoadingstate extends CartState {}

final class AddcartproductSuccessedstate extends CartState {}

final class AddcartproductFailedstate extends CartState {
  final String errorMessage;

  AddcartproductFailedstate({required this.errorMessage});
}
/* ------------------------------------------- */

final class DeletecartproductLoadingstate extends CartState {}

final class DeletecartproductSuccessedstate extends CartState {}

final class DeletecartproductFailedstate extends CartState {
  final String errorMessage;

  DeletecartproductFailedstate({required this.errorMessage});
}
/*------------------------------------------- */

final class GetOrderSummaryLoadingState extends CartState {}

final class GetOrderSummarySuccessState extends CartState {
  final double? subtotalPrice;
  final double? totalPrice;
  final double? deliveryFee;
  final double? discount;

  GetOrderSummarySuccessState({
    required this.subtotalPrice,
    required this.totalPrice,
    required this.deliveryFee,
    required this.discount,
  });
}

final class GetOrderSummaryFailedState extends CartState {
  final String errorMessage;
  GetOrderSummaryFailedState({required this.errorMessage});
}

/*------------------------------------------- */
final class GetOrderaddressLoadingState extends CartState {}

final class GetOrderaddressSuccessState extends CartState {
  final AddressModel orderAddress;
  GetOrderaddressSuccessState({required this.orderAddress});
}

final class GetOrderaddressFailedState extends CartState {
  final String errorMessage;
  GetOrderaddressFailedState({required this.errorMessage});
}

/*------------------------------------------- */
final class MakePaymentLoadingState extends CartState {}

final class MakePaymentSuccessState extends CartState {}

final class MakePaymentFailedState extends CartState {
  final String error;
  MakePaymentFailedState(this.error);
}
