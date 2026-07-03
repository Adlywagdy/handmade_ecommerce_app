import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/customer/shop_details/services/customer_seller_profile_service.dart';

part 'seller_profile_state.dart';

class SellerProfileCubit extends Cubit<SellerProfileState> {
  SellerProfileCubit() : super(SellerProfileInitial());

  Future<void> getSellerProfileById(String sellerId) async {
    emit(SellerProfileLoading());

    try {
      final seller = await getsellerdata(sellerId);
      emit(SellerProfileLoaded(seller));
    } on StateError {
      emit(SellerProfileNotFound());
    } catch (e) {
      emit(SellerProfileError(e.toString()));
    }
  }
}
