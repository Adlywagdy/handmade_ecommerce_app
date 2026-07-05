import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chatbot_product_model.dart';

class FirestoreChatbotProductsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ChatbotProductModel>> getApprovedProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('status', isEqualTo: 'approved')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      return ChatbotProductModel.fromFirestore(
        id: doc.id,
        data: doc.data(),
      );
    }).toList();
  }
}