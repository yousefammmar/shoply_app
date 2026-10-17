
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= FAVORITES REFERENCE =================

  CollectionReference<Map<String, dynamic>> _favoritesRef() {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('User is not logged in');
    }

    return _firestore
        .collection('User')
        .doc(user.uid)
        .collection('favorites');
  }

  // ================= ADD FAVORITE =================

  Future<void> addFavorite(String productId) async {
    await _favoritesRef().doc(productId).set({
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= REMOVE FAVORITE =================

  Future<void> removeFavorite(String productId) async {
    await _favoritesRef().doc(productId).delete();
  }

  // ================= WATCH FAVORITES =================

  Stream<Set<String>> watchFavorites() {
    return _favoritesRef().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  // ================= CHECK FAVORITE =================

  Future<bool> isFavorite(String productId) async {
    final snapshot = await _favoritesRef().doc(productId).get();

    return snapshot.exists;
  }
}
