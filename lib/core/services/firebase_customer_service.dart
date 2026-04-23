import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';

class FirebaseCustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final CollectionReference<Map<String, dynamic>> _usersCollection =
      _firestore.collection('users');

  /// Get current user's profile data from Firestore
  Future<CustomerModel?> getCustomerData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _usersCollection.doc(user.uid).get();
    if (!doc.exists) return null;

    final data = doc.data() ?? <String, dynamic>{};
    return CustomerModel.fromMap({
      ...data,
      'uid': data['uid'] ?? user.uid,
      'fullName': data['fullName'] ?? data['name'] ?? user.displayName ?? '',
      'email': data['email'] ?? user.email ?? '',
      'provider': data['provider'] ?? 'email',
    });
  }

  /// Update customer profile
  Future<void> updateCustomerProfile({
    required String name,
    required String phone,
    String? image,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _usersCollection.doc(user.uid).set({
      'uid': user.uid,
      'fullName': name,
      'name': name,
      'phone': phone,
      if (image != null) 'image': image,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (user.displayName != name) {
      await user.updateDisplayName(name);
    }
  }

  /// Set default address for customer
  Future<void> setDefaultAddress(AddressModel address) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _usersCollection.doc(user.uid).set({
      'address': address.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get customer notifications
  Future<List<String>> getNotifications() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final doc = await _usersCollection
        .doc(user.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .get();

    return doc.docs
        .map((notificationDoc) => notificationDoc.data()['message'])
        .whereType<String>()
        .toList();
  }
}
