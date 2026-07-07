import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/services/firebase_product_service.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({FirebaseProductService? productService})
    : _productService = productService ?? FirebaseProductService(),
      super(SearchInitial());

  final FirebaseProductService _productService;

  CategoryModel? selectedCategory;
  /* ------------------------------------------- */

  Future<void> resetSearchState() async {
    searchedproductsList = [];
    filteredproductsList = [];
    selectedCategory = null;
    emit(SearchInitial());
  }

  List<CategoryModel> categoriesList = [];
  Future<void> getCategories() async {
    emit(GetCategoriesLoadingstate());
    try {
      categoriesList = await _productService.getCategories();
      if (isClosed) return;
      emit(GetCategoriesSuccessedstate());
    } catch (e) {
      if (isClosed) return;
      emit(GetCategoriesFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  List<ProductModel> searchedproductsList = [];
  Future<void> searchproducts({required String productname}) async {
    emit(SearchProductsLoadingstate());
    try {
      searchedproductsList = await _productService.searchProducts(productname);
      if (isClosed) return;
      emit(SearchProductsSuccessedstate());
    } catch (e) {
      if (isClosed) return;
      emit(SearchProductsFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  List<ProductModel> filteredproductsList = [];
  Future<void> filterproducts({
    String? categoryname,
    double? minprice,
    double? maxprice,
    double? rating /* + filter parameters */,
  }) async {
    emit(FilterProductsLoadingstate());
    try {
      String? categoryId;
      if (categoryname != null && categoryname.trim().isNotEmpty) {
        final normalized = categoryname.trim().toLowerCase();
        for (final category in categoriesList) {
          if (category.categorytitle.toLowerCase() == normalized) {
            categoryId = category.id ?? category.categorytitle;
            break;
          }
        }
      }

      filteredproductsList = await _productService.filterProducts(
        categoryId: categoryId,
        minPrice: minprice,
        maxPrice: maxprice,
        minRating: rating,
      );
      if (isClosed) return;
      emit(FilterProductsSuccessedstate());
    } catch (e) {
      if (isClosed) return;
      emit(FilterProductsFailedstate(errorMessage: e.toString()));
    }
  }
}
