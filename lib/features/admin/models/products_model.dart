class ProductsModel {
  final int productId;
  final String name;
  final double price;
  final String currency;
  final String vendorName;
  final String productImage;
  final String status; // 'pending' | 'approved' | 'rejected'

  const ProductsModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.currency,
    required this.vendorName,
    required this.productImage,
    required this.status,
  });
}
