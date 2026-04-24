import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/services/firebase_product_service.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({FirebaseProductService? productService})
    : _productService = productService ?? FirebaseProductService(),
      super(HomeInitial());

  final FirebaseProductService _productService;

  /* ------------------------------------------- */
  Future<void> getFeaturedProducts() async {
    emit(GetFeaturedLoadingstate());
    try {
      final featuredProducts = await _productService.getFeaturedProducts();

      emit(GetFeaturedSuccessedstate(products: featuredProducts));
    } catch (e) {
      emit(GetFeaturedFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  Future<void> getTopRatedProducts() async {
    emit(GetTopRatedLoadingstate());
    try {
      final topRatedProducts = await _productService.getTopRatedProducts();

      emit(GetTopRatedSuccessedstate(products: topRatedProducts));
    } catch (e) {
      emit(GetTopRatedFailedstate(errorMessage: e.toString()));
    }
  }
}
