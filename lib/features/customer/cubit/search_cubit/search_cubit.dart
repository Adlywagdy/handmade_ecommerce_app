import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_categorieslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  CategoryModel? selectedCategory;
  /* ------------------------------------------- */

  Future<void> resetSearchState(BuildContext context) async {
    searchedproductsList = [];
    filteredproductsList = [];
    BlocProvider.of<SearchCubit>(context).selectedCategory = null;
    emit(SearchInitial());
  }

  List<CategoryModel> categoriesList = [];
  Future<void> getCategories() async {
    emit(GetCategoriesLoadingstate());
    try {
      // Simulate a delay for loading categories
      await Future.delayed(const Duration(seconds: 2), () {});

      // should trigger get categories logic here
      categoriesList = testcategorieslistdata; // replace with actual data
      emit(GetCategoriesSuccessedstate());
    } catch (e) {
      emit(GetCategoriesFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  List<ProductModel> searchedproductsList = [];
  Future<void> searchproducts({required String productname}) async {
    emit(SearchProductsLoadingstate());
    try {
      // Simulate a delay for loading categories
      await Future.delayed(const Duration(seconds: 2), () {});

      // should trigger search logic here
      searchedproductsList = productsListData; // replace with actual data
      emit(SearchProductsSuccessedstate());
    } catch (e) {
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
      // Simulate a delay for loading categories
      await Future.delayed(const Duration(seconds: 2), () {});

      // should trigger filter logic here
      filteredproductsList = productsListData; // replace with actual data
      emit(FilterProductsSuccessedstate());
    } catch (e) {
      emit(FilterProductsFailedstate(errorMessage: e.toString()));
    }
  }
}
