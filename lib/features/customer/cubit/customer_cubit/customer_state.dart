part of 'customer_cubit.dart';

abstract class CustomerState {}

final class CustomerInitial extends CustomerState {}

/* ------------------------------------------- */
final class GetCustomerdataLoadingstate extends CustomerState {}

final class GetCustomerdataSuccessedstate extends CustomerState {
  final CustomerModel customer;
  GetCustomerdataSuccessedstate({required this.customer});
}

final class GetCustomerdataFailedstate extends CustomerState {
  final String errorMessage;

  GetCustomerdataFailedstate({required this.errorMessage});
}

/* ------------------------------------------- */
final class AddorUpdateCustomeraddressLoadingstate extends CustomerState {}

final class AddorUpdateCustomeraddressSuccessedstate extends CustomerState {
  final CustomerModel customer;
  AddorUpdateCustomeraddressSuccessedstate({required this.customer});
}

final class AddorUpdateCustomeraddressFailedstate extends CustomerState {
  final String errorMessage;

  AddorUpdateCustomeraddressFailedstate({required this.errorMessage});
}

/* ------------------------------------------- */
final class NotificationsLoadingstate extends CustomerState {}

final class NotificationsSuccessedstate extends CustomerState {
  final List<String> notifications;
  NotificationsSuccessedstate({required this.notifications});
}

final class NotificationsFailedstate extends CustomerState {
  final String errorMessage;

  NotificationsFailedstate({required this.errorMessage});
}
