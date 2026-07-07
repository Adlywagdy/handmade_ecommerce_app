import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/customer/shop_details/data/customer_seller_profile_service.dart';

part 'seller_profile_state.dart';

class SellerProfileCubit extends Cubit<SellerProfileState> {
  SellerProfileCubit({CustomerSellerProfileService? service})
      : _service = service ?? CustomerSellerProfileService(),
        super(SellerProfileInitial());

  final CustomerSellerProfileService _service;

  Future<void> getSellerProfileById(String sellerId) async {
    emit(SellerProfileLoading());

    try {
      final seller = await _service.getSellerProfile(sellerId);
      emit(SellerProfileLoaded(seller));
    } on StateError {
      emit(SellerProfileNotFound());
    } catch (e) {
      emit(SellerProfileError(e.toString()));
    }
  }
}
