import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';

class FirebaseCustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user's profile data from Firestore
  Future<CustomerModel?> getCustomerData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('customers').doc(user.uid).get();

      if (!doc.exists) return null;

      final data = doc.data() ?? <String, dynamic>{};
      return CustomerModel.fromMap({
        ...data,
        'email': data['email'] ?? user.email ?? '',
        'password': '',
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Update customer profile
  Future<void> updateCustomerProfile({
    required String name,
    required String phone,
    String? image,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('customers').doc(user.uid).set({
        'name': name,
        'phone': phone,
        if (image != null) 'image': image,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Set default address for customer
  Future<void> setDefaultAddress(AddressModel address) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('customers').doc(user.uid).set({
        'address': address.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Get customer notifications
  Future<List<String>> getNotifications() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final doc = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();

      return doc.docs.map((doc) => doc['message'] as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Create or update customer on registration
  Future<void> createCustomerProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      await _firestore.collection('customers').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'image': null,
        'address': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }
}
