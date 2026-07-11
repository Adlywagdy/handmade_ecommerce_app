part of 'customer_cubit.dart';

sealed class CustomerState {}

final class CustomerInitial extends CustomerState {}

final class CustomerDataLoading extends CustomerState {}

final class CustomerDataSuccess extends CustomerState {
  final CustomerModel customer;
  CustomerDataSuccess({required this.customer});
}

final class CustomerDataError extends CustomerState {
  final String message;
  CustomerDataError({required this.message});
}

final class ImageUploadLoading extends CustomerState {}

final class ImageUploadSuccess extends CustomerState {
  final CustomerModel customer;
  ImageUploadSuccess({required this.customer});
}

final class ImageUploadError extends CustomerState {
  final String message;
  ImageUploadError({required this.message});
}
