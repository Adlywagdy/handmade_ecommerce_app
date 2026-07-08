import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/features/notifications/data/services/notification_generator.dart';
import '../models/seller_model.dart';

class SellerFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentSellerId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('No authenticated user found');
    }
    return uid;
  }

  // ─── Categories ───
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _db
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
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

  /// Stream all products for the current seller
  Stream<List<SellerProductModel>> getProductsStream() {
    return _db
        .collection('products')
        .where('sellerId', isEqualTo: currentSellerId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SellerProductModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  /// Add a new product
  Future<void> addProduct(SellerProductModel product) async {
    try {
      final map = product.toMap();
      map['sellerId'] = currentSellerId; // Link product to seller
      map['createdAt'] = FieldValue.serverTimestamp();

      // Attach seller info so customer app displays it correctly
      final userDoc = await _db.collection('users').doc(currentSellerId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        map['seller'] = {
          'id': currentSellerId,
          'name': userData?['name'] ?? '',
          'email': userData?['email'] ?? '',
        };
      }

      await _db.collection('products').add(map);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  /// Update an existing product
  Future<void> updateProduct(SellerProductModel product) async {
    try {
      // Get the old product to check if price dropped
      final oldDoc = await _db.collection('products').doc(product.id).get();
      double oldPrice = 0;
      if (oldDoc.exists) {
        oldPrice = (oldDoc.data()?['price'] ?? 0).toDouble();
      }

      final map = product.toMap();
      
      // Attach seller info so customer app displays it correctly
      final userDoc = await _db.collection('users').doc(currentSellerId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        map['seller'] = {
          'id': currentSellerId,
          'name': userData?['name'] ?? '',
          'email': userData?['email'] ?? '',
        };
      }

      await _db.collection('products').doc(product.id).update({
        ...map,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // If price dropped, notify wishlist users
      if (oldPrice > 0 && product.price < oldPrice) {
        final wishlistItems = await _db
            .collectionGroup('items')
            .where('productId', isEqualTo: product.id)
            .get();

        for (final doc in wishlistItems.docs) {
          final userId = doc.reference.parent.parent?.id;
          if (userId != null) {
            NotificationGenerator.onPriceDrop(
              customerId: userId,
              productName: product.name,
              oldPrice: oldPrice.toString(),
              newPrice: product.price.toString(),
            );
          }
        }
      }
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
      // First try to fetch using the new sellerIds array
      QuerySnapshot snapshot;
      try {
        snapshot = await _db
            .collection('orders')
            .where('sellerIds', arrayContains: currentSellerId)
            .get();
      } catch (e) {
        // Fallback for older orders without sellerIds
        snapshot = await _db
            .collection('orders')
            .where('sellerId', isEqualTo: currentSellerId)
            .get();
      }

      if (snapshot.docs.isEmpty) {
        // Try fallback if array query returned empty just in case
        final fallbackSnapshot = await _db
            .collection('orders')
            .where('sellerId', isEqualTo: currentSellerId)
            .get();
        if (fallbackSnapshot.docs.isNotEmpty) {
          snapshot = fallbackSnapshot;
        }
      }

      if (snapshot.docs.isEmpty) {
        return [];
      }

      // Filter out archived orders, parse, and sort in memory
      final orders = snapshot.docs
          .where((doc) => (doc.data() as Map<String, dynamic>)['archived'] != true)
          .map((doc) => SellerOrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Sort by orderDate descending in memory
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      return orders;
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  /// Stream all orders for the current seller
  Stream<List<SellerOrderModel>> getOrdersStream() {
    // Note: Firestore doesn't support an OR query combining arrayContains and isEqualTo across different fields cleanly without composites.
    // For streams, we will rely on sellerIds. New orders will have it. 
    // To be perfectly backwards compatible, we can merge streams, but it's complex.
    // Assuming 'sellerIds' is primarily used going forward.
    return _db
        .collection('orders')
        .where('sellerIds', arrayContains: currentSellerId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .where((doc) => doc.data()['archived'] != true)
              .map((doc) => SellerOrderModel.fromMap(doc.data(), doc.id))
              .toList();
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return orders;
        });
  }

  /// Update the status of an order
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final orderDoc = await _db.collection('orders').doc(orderId).get();
      if (!orderDoc.exists) {
        throw Exception('Order not found');
      }

      final orderData = orderDoc.data();
      final customerId = orderData?['customerId']?.toString();

      // Update root order and customer order using a batch
      final batch = _db.batch();

      batch.update(_db.collection('orders').doc(orderId), {
        'status': newStatus,
      });

      // Update customer subcollection order if customer ID exists
      if (customerId != null && customerId.isNotEmpty) {
        batch.set(
          _db
              .collection('customers')
              .doc(customerId)
              .collection('orders')
              .doc(orderId),
          {'status': newStatus},
          SetOptions(merge: true),
        );
      }

      // Restore stock if the seller cancels the order
      if (newStatus.toLowerCase() == 'cancelled') {
        final itemsList =
            orderData?['items'] ?? orderData?['products'] as List?;
        if (itemsList != null && itemsList.isNotEmpty) {
          for (final item in itemsList) {
            if (item is Map) {
              final String? productId =
                  item['productId']?.toString() ?? item['id']?.toString();
              final int quantity = (item['quantity'] as num?)?.toInt() ?? 1;
              if (productId != null && productId.isNotEmpty) {
                batch.update(_db.collection('products').doc(productId), {
                  'stock': FieldValue.increment(quantity),
                  'quantity': FieldValue.increment(quantity),
                });
              }
            }
          }
        }
      }

      await batch.commit();

      if (customerId != null && customerId.isNotEmpty) {
        // Trigger notification to customer
        NotificationGenerator.onOrderStatusChanged(
          customerId: customerId,
          orderId: orderId,
          newStatus: newStatus,
        );

        // If marked as delivered, trigger Review Request for products in this order
        if (newStatus.toLowerCase() == 'delivered') {
          final itemsList = orderData?['items'] as List?;
          if (itemsList != null && itemsList.isNotEmpty) {
            for (final item in itemsList) {
              final String? productId = item['productId']?.toString();
              final String? productName = item['productName']?.toString();
              if (productId != null && productName != null) {
                NotificationGenerator.onReviewRequest(
                  customerId: customerId,
                  productName: productName,
                  productId: productId,
                );
              }
            }
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Archive an order (hide from seller list without deleting)
  Future<void> archiveOrder(String orderId) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'archived': true,
        'archivedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to archive order: $e');
    }
  }

  // ─── Dashboard Stats ───

  /// Fetch dashboard stats dynamically
  Future<SellerDashboardStats> getDashboardStats(
    List<SellerOrderModel> orders, {
    int productCount = 0,
  }) async {
    try {
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
        if (order.status.toLowerCase() == 'completed' ||
            order.status.toLowerCase() == 'delivered') {
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
        totalProducts: productCount.toString(),
        weeklySales: weeklySales,
        monthlySales: monthlySales,
        revenueGrowth: calculateGrowth(currentWeekRevenue, previousWeekRevenue),
        ordersGrowth: calculateGrowth(
          currentWeekOrders.toDouble(),
          previousWeekOrders.toDouble(),
        ),
      );
    } catch (e) {
      throw Exception('Failed to load dashboard stats: $e');
    }
  }
}
