import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register function
  Future<String?> registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      // 1. Create user
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // 2. Check if user created
      if (user != null) {
        // 3. Save additional user info in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Login function
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
