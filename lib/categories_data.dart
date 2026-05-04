// import 'package:cloud_firestore/cloud_firestore.dart';

// Categories Data Model
// class CategoryData {
//   final String categoryId;
//   final String nameEN;
//   final String nameAR;
//   final String icon;
//   final bool isActive;
//   final int order;
//   final int productsCount;

//   CategoryData({
//     required this.categoryId,
//     required this.nameEN,
//     required this.nameAR,
//     required this.icon,
//     required this.isActive,
//     required this.order,
//     required this.productsCount,
//   });

//   /// Convert to Firestore document
//   Map<String, dynamic> toFirestoreDocument() {
//     return {
//       'categoryId': categoryId,
//       'nameEN': nameEN,
//       'nameAR': nameAR,
//       'icon': icon,
//       'isActive': isActive,
//       'order': order,
//       'productsCount': productsCount,
//       'createdAt': FieldValue.serverTimestamp(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     };
//   }
// }

// // Categories data based on the handmade products
// final List<CategoryData> categoriesData = [
//   CategoryData(
//     categoryId: 'candles',
//     nameEN: 'Candles',
//     nameAR: 'الشموع',
//     icon: 'https://cdn-icons-png.flaticon.com/128/3621/3621898.png',
//     isActive: true,
//     order: 1,
//     productsCount: 6,
//   ),
//   CategoryData(
//     categoryId: 'ceramic_vases',
//     nameEN: 'Ceramic Vases',
//     nameAR: 'مزهريات سيراميك',
//     icon: 'https://cdn-icons-png.flaticon.com/128/2763/2763472.png',
//     isActive: true,
//     order: 2,
//     productsCount: 13,
//   ),
//   CategoryData(
//     categoryId: 'macrame',
//     nameEN: 'Macrame',
//     nameAR: 'ماكريميه',
//     icon: 'https://cdn-icons-png.flaticon.com/128/2695/2695950.png',
//     isActive: true,
//     order: 3,
//     productsCount: 0, // Will be updated after products count
//   ),
//   CategoryData(
//     categoryId: 'wooden_shelves',
//     nameEN: 'Wooden Shelves',
//     nameAR: 'رفوف خشبية',
//     icon: 'https://cdn-icons-png.flaticon.com/128/11333/11333088.png',
//     isActive: true,
//     order: 4,
//     productsCount: 0, // Will be updated after products count
//   ),
//   CategoryData(
//     categoryId: 'handmade_lamps',
//     nameEN: 'Handmade Lamps',
//     nameAR: 'مصابيح يدوية',
//     icon: 'https://cdn-icons-png.flaticon.com/128/3144/3144456.png',
//     isActive: true,
//     order: 5,
//     productsCount: 0, // Will be updated after products count
//   ),
//   CategoryData(
//     categoryId: 'crochet_products',
//     nameEN: 'Crochet Products',
//     nameAR: 'منتجات الكروشيه',
//     icon: 'https://cdn-icons-png.flaticon.com/128/3996/3996332.png',
//     isActive: true,
//     order: 6,
//     productsCount: 0, // Will be updated after products count
//   ),
// ];

// /// Upload categories to Firestore
// Future<void> uploadCategoriesToFirestore() async {
//   try {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final CollectionReference categoriesRef = firestore.collection(
//       'categories',
//     );

//     // Delete existing categories (optional - comment out to keep existing)
//     // var snapshot = await categoriesRef.get();
//     // for (var doc in snapshot.docs) {
//     //   await doc.reference.delete();
//     // }

//     // Upload new categories
//     for (var category in categoriesData) {
//       await categoriesRef
//           .doc(category.categoryId)
//           .set(category.toFirestoreDocument(), SetOptions(merge: true));
//     }

//     print('✅ Categories uploaded successfully!');
//   } catch (e) {
//     print('❌ Error uploading categories: $e');
//     rethrow;
//   }
// }
