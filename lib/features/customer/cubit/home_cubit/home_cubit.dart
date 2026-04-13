import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  /* ------------------------------------------- */
  void getFeaturedProducts() async {
    emit(GetFeaturedLoadingstate());
    try {
      // Simulate a delay for loading featured products
      await Future.delayed(const Duration(seconds: 2), () {});

      // should trigger get featured products logic here

      emit(
        GetFeaturedSuccessedstate(products: productsListData),
      ); // replace with actual data
    } catch (e) {
      emit(GetFeaturedFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  void getTopRatedProducts() async {
    emit(GetTopRatedLoadingstate());
    try {
      // Simulate a delay for loading top-rated products
      await Future.delayed(const Duration(seconds: 2), () {});

      // should trigger get top-rated products logic here

      emit(
        GetTopRatedSuccessedstate(products: productsListData),
      ); // replace with actual data
    } catch (e) {
      emit(GetTopRatedFailedstate(errorMessage: e.toString()));
    }
  }
}
