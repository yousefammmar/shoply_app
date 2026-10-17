
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= CART REFERENCE =================

  CollectionReference<Map<String, dynamic>> _cartRef() {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('User is not logged in');
    }

    return _firestore
        .collection('User')
        .doc(user.uid)
        .collection('cart');
  }

  // ================= ADD TO CART =================

  Future<void> addToCart(
    String productId, {
    int quantity = 1,
  }) async {
    if (quantity < 1) {
      throw ArgumentError('Quantity must be at least 1');
    }

    final productRef = _cartRef().doc(productId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(productRef);

      if (snapshot.exists) {
        final currentQuantity =
            (snapshot.data()?['quantity'] as num?)?.toInt() ?? 0;

        transaction.update(productRef, {
          'quantity': currentQuantity + quantity,
        });
      } else {
        transaction.set(productRef, {
          'quantity': quantity,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  // ================= UPDATE QUANTITY =================

  Future<void> updateQuantity(
    String productId,
    int quantity,
  ) async {
    if (quantity < 1) {
      throw ArgumentError('Quantity must be at least 1');
    }

    await _cartRef().doc(productId).update({
      'quantity': quantity,
    });
  }

  // ================= REMOVE FROM CART =================

  Future<void> removeFromCart(String productId) async {
    await _cartRef().doc(productId).delete();
  }

  // ================= WATCH CART =================

  Stream<Map<String, int>> watchCart() {
    return _cartRef().snapshots().map((snapshot) {
      return {
        for (final doc in snapshot.docs)
          doc.id: (doc.data()['quantity'] as num?)?.toInt() ?? 1,
      };
    });
  }

  // ================= CLEAR CART =================

  Future<void> clearCart() async {
    final cartItems = await _cartRef().get();

    if (cartItems.docs.isEmpty) return;

    final batch = _firestore.batch();

    for (final doc in cartItems.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
