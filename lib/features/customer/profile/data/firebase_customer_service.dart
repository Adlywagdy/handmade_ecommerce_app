import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/home/data/customer_model.dart';

class FirebaseCustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  User? get _user => _auth.currentUser;

  // ─── Profile ──────────────────────────────────────────

  Future<CustomerModel?> getCustomerData() async {
    final user = _user;
    if (user == null) return null;

    final doc = await _users.doc(user.uid).get();
    if (!doc.exists) return null;

    final data = doc.data() ?? {};
    return CustomerModel.fromMap({
      ...data,
      'uid': data['uid'] ?? user.uid,
      'fullName': data['fullName'] ?? data['name'] ?? user.displayName ?? '',
      'email': data['email'] ?? user.email ?? '',
      'provider': data['provider'] ?? 'email',
    });
  }

  Future<void> updateCustomerProfile({
    required String name,
    required String phone,
    String? image,
  }) async {
    final user = _user;
    if (user == null) throw Exception('User not authenticated');

    await _users.doc(user.uid).set({
      'uid': user.uid,
      'fullName': name,
      'name': name,
      'phone': phone,
      'image': image,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (user.displayName != name) {
      await user.updateDisplayName(name);
    }
  }

  // ─── Address ──────────────────────────────────────────

  Future<void> setDefaultAddress(AddressModel address) async {
    final user = _user;
    if (user == null) throw Exception('User not authenticated');

    await _users.doc(user.uid).set({
      'address': address.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> setDefaultDeliveryDetails({
    required AddressModel address,
    required String phone,
  }) async {
    final user = _user;
    if (user == null) throw Exception('User not authenticated');

    await _users.doc(user.uid).set({
      'address': address.toMap(),
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ─── Notifications ────────────────────────────────────

  Future<List<String>> getNotifications() async {
    final user = _user;
    if (user == null) return [];

    final snapshot = await _users
        .doc(user.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => doc.data()['message'])
        .whereType<String>()
        .toList();
  }
}
