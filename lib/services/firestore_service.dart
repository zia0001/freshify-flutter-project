import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> saveOrder(String uid, Map<String, dynamic> order) async {
    await _db.collection('orders').add({
      'userId': uid,
      ...order,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Fallback: load sample products from assets/products.json
  Future<List<Map<String, dynamic>>> loadLocalProducts() async {
    final s = await rootBundle.loadString('assets/products.json');
    final list = json.decode(s) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
