part of 'customer_cubit.dart';

sealed class CustomerState {}

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
final class NotificationsLoadingstate extends CustomerState {}

final class NotificationsSuccessedstate extends CustomerState {
  final List<String> notifications;
  NotificationsSuccessedstate({required this.notifications});
}

final class NotificationsFailedstate extends CustomerState {
  final String errorMessage;

  NotificationsFailedstate({required this.errorMessage});
}

/* ------------------------------------------- */
final class ImageUploadLoadingstate extends CustomerState {}

final class ImageUploadSuccessedstate extends CustomerState {
  final CustomerModel customer;
  ImageUploadSuccessedstate({required this.customer});
}

final class ImageUploadFailedstate extends CustomerState {
  final String errorMessage;

  ImageUploadFailedstate({required this.errorMessage});
}
