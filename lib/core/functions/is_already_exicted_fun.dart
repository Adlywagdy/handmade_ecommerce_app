import 'package:handmade_ecommerce_app/core/models/product_model.dart';

bool isItemExictedFun({
  required List<ProductModel> productslist,
  required String productID,
}) {
  return productslist.any((product) => product.id == productID);
}
