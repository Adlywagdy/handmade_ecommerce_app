import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/services/firebase_product_service.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({FirebaseProductService? productService})
    : _productService = productService ?? FirebaseProductService(),
      super(HomeInitial());

  final FirebaseProductService _productService;

  Future<void> getFeaturedProducts() async {
    emit(FeaturedLoading());
    try {
      final featuredProducts = await _productService.getFeaturedProducts();
      emit(FeaturedSuccess(products: featuredProducts));
    } catch (e) {
      emit(FeaturedError(message: e.toString()));
    }
  }

  Future<void> getTopRatedProducts() async {
    emit(TopRatedLoading());
    try {
      final topRatedProducts = await _productService.getTopRatedProducts();
      emit(TopRatedSuccess(products: topRatedProducts));
    } catch (e) {
      emit(TopRatedError(message: e.toString()));
    }
  }
}
