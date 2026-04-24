import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/seller_model.dart';
import '../models/data/seller_mock_data.dart'; // fallback data

class SellerFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get currentSellerId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('No authenticated user found');
    }
    return uid;
  }

  // ─── Products ───

  /// Fetch all products for the current seller
  Future<List<SellerProductModel>> getProducts() async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('sellerId', isEqualTo: currentSellerId)
          .get();

      if (snapshot.docs.isEmpty) {
        return []; // Return empty instead of mock data so UI updates properly
      }

      return snapshot.docs
          .map((doc) => SellerProductModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  /// Upload images to Firebase Storage and return the download URLs
  Future<List<String>> uploadProductImages(List<File> images) async {
    List<String> downloadUrls = [];
    try {
      for (var image in images) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_' + image.path.split('/').last;
        Reference ref = _storage.ref().child('product_images/$currentSellerId/$fileName');
        
        UploadTask uploadTask = ref.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
  }

  /// Add a new product
  Future<void> addProduct(SellerProductModel product) async {
    try {
      final map = product.toMap();
      map['sellerId'] = currentSellerId; // Link product to seller
      map['createdAt'] = FieldValue.serverTimestamp();
      
      await _db.collection('products').add(map);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  /// Update an existing product
  Future<void> updateProduct(SellerProductModel product) async {
    try {
      await _db.collection('products').doc(product.id).update(product.toMap());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // ─── Orders ───

  /// Fetch all orders for the current seller
  Future<List<SellerOrderModel>> getOrders() async {
    try {
      final snapshot = await _db
          .collection('orders')
          .where('sellerId', isEqualTo: currentSellerId)
          .orderBy('orderDate', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return []; // Return empty instead of mock data so UI updates properly
      }

      return snapshot.docs
          .map((doc) => SellerOrderModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  /// Update the status of an order
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _db.collection('orders').doc(orderId).update({'status': newStatus});
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // ─── Dashboard Stats ───

  /// Fetch dashboard stats dynamically
  Future<SellerDashboardStats> getDashboardStats() async {
    try {
      final orders = await getOrders();
      
      double totalRevenue = 0;
      int completedOrders = 0;
      double currentWeekRevenue = 0;
      double previousWeekRevenue = 0;
      int currentWeekOrders = 0;
      int previousWeekOrders = 0;
      List<double> weeklySales = List.filled(7, 0.0);
      List<double> monthlySales = List.filled(6, 0.0);
      
      final now = DateTime.now();

      for (var order in orders) {
        // Only count completed/delivered orders as revenue
        if (order.status.toLowerCase() == 'completed' || order.status.toLowerCase() == 'delivered') {
          totalRevenue += order.totalAmount;
          completedOrders++;
          
          try {
            final date = DateTime.parse(order.orderDate);
            final diffInDays = now.difference(date).inDays;

            // Growth calculation logic
            if (diffInDays >= 0 && diffInDays < 7) {
              currentWeekRevenue += order.totalAmount;
              currentWeekOrders++;
              
              // Weekly chart index
              final index = 6 - diffInDays;
              weeklySales[index] += order.totalAmount;
            } else if (diffInDays >= 7 && diffInDays < 14) {
              previousWeekRevenue += order.totalAmount;
              previousWeekOrders++;
            }

            // Monthly logic (Last 6 months)
            final yearDiff = now.year - date.year;
            final monthDiff = (now.month - date.month) + (yearDiff * 12);
            if (monthDiff >= 0 && monthDiff < 6) {
              final index = 5 - monthDiff;
              monthlySales[index] += order.totalAmount;
            }
          } catch (_) {}
        }
      }

      // Calculate percentages
      String calculateGrowth(double current, double previous) {
        if (previous == 0) return current > 0 ? '+100%' : '0%';
        final growth = ((current - previous) / previous) * 100;
        return '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%';
      }

      return SellerDashboardStats(
        totalSales: totalRevenue.toStringAsFixed(2),
        totalOrders: completedOrders.toString(),
        totalRevenue: totalRevenue.toStringAsFixed(2),
        totalProducts: '0', 
        weeklySales: weeklySales,
        monthlySales: monthlySales,
        revenueGrowth: calculateGrowth(currentWeekRevenue, previousWeekRevenue),
        ordersGrowth: calculateGrowth(currentWeekOrders.toDouble(), previousWeekOrders.toDouble()),
      );
    } catch (e) {
      throw Exception('Failed to load dashboard stats: $e');
    }
  }
}
