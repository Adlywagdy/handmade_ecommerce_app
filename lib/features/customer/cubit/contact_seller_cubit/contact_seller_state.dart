part of 'contact_seller_cubit.dart';

sealed class ContactSellerState {}

final class ContactSellerInitial extends ContactSellerState {}

final class ContactSellerLoading extends ContactSellerState {}

final class ContactSellerSuccess extends ContactSellerState {}

final class ContactSellerFailure extends ContactSellerState {
  ContactSellerFailure(this.message);

  final String message;
}
