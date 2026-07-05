part of 'seller_profile_cubit.dart';

sealed class SellerProfileState {}

final class SellerProfileInitial extends SellerProfileState {}

final class SellerProfileLoading extends SellerProfileState {}

final class SellerProfileLoaded extends SellerProfileState {
  SellerProfileLoaded(this.seller);

  final SellerModel seller;
}

final class SellerProfileNotFound extends SellerProfileState {}

final class SellerProfileError extends SellerProfileState {
  SellerProfileError(this.message);

  final String message;
}
