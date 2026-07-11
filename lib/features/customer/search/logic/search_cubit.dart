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
  List<CategoryModel> categoriesList = [];
  List<ProductModel> searchedproductsList = [];
  List<ProductModel> filteredproductsList = [];

  Future<void> resetSearchState() async {
    searchedproductsList = [];
    filteredproductsList = [];
    selectedCategory = null;
    emit(SearchInitial());
  }

  Future<void> getCategories() async {
    emit(CategoriesLoading());
    try {
      categoriesList = await _productService.getCategories();
<<<<<<< HEAD
      if (isClosed) return;
      emit(GetCategoriesSuccessedstate());
    } catch (e) {
      if (isClosed) return;
      emit(GetCategoriesFailedstate(errorMessage: e.toString()));
=======
      emit(CategoriesSuccess());
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
>>>>>>> main
    }
  }

  Future<void> searchproducts({required String productname}) async {
    emit(SearchProductsLoading());
    try {
      searchedproductsList = await _productService.searchProducts(productname);
<<<<<<< HEAD
      if (isClosed) return;
      emit(SearchProductsSuccessedstate());
    } catch (e) {
      if (isClosed) return;
      emit(SearchProductsFailedstate(errorMessage: e.toString()));
=======
      emit(SearchProductsSuccess());
    } catch (e) {
      emit(SearchProductsError(message: e.toString()));
>>>>>>> main
    }
  }

  Future<void> filterproducts({
    String? categoryname,
    double? minprice,
    double? maxprice,
    double? rating,
  }) async {
    emit(FilterProductsLoading());
    try {
      String? resolvedCategoryId;
      if (categoryname != null && categoryname.trim().isNotEmpty) {
        if (categoriesList.isEmpty) {
          await getCategories();
        }
        final normalized = categoryname.trim().toLowerCase();
        for (final category in categoriesList) {
          if (category.categorytitle.toLowerCase() == normalized) {
            resolvedCategoryId = category.id ?? category.categorytitle;
            break;
          }
        }
      }

      filteredproductsList = await _productService.filterProducts(
        categoryId: resolvedCategoryId,
        minPrice: minprice,
        maxPrice: maxprice,
        minRating: rating,
      );
<<<<<<< HEAD
      if (isClosed) return;
      emit(FilterProductsSuccessedstate());
    } catch (e) {
      if (isClosed) return;
      emit(FilterProductsFailedstate(errorMessage: e.toString()));
=======
      emit(FilterProductsSuccess());
    } catch (e) {
      emit(FilterProductsError(message: e.toString()));
>>>>>>> main
    }
  }
}
