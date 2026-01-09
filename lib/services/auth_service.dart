import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Sign Up logic
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
    
    // Updates the Firebase Auth profile name
    await cred.user!.updateDisplayName(name);
    
    final uid = cred.user!.uid;
    try {
      await _db.collection('users').doc(uid).set({
        'name': name,
        'phone': phone,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Firestore record failed: $e");
    }
    
    notifyListeners(); 
    return cred;
  }

  // Sign In logic
  Future<UserCredential> signIn({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
    return cred;
  }

  // Sign Out logic
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      notifyListeners(); // Ensure UI knows user is null
    }
  }
}