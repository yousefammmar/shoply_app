import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesRepo 
{
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  final FirebaseAuth _auth= FirebaseAuth.instance;
  CollectionReference<Map<String, dynamic>> _favoritesRef()
  {
    final user= _auth.currentUser;
    if(user==null)
    {
      throw StateError('User Not Logged in.');
    }
    return _firestore .collection('User'). doc(user.uid).collection('favorites');
  }
  Future<void> addFavorite(String productId)async
  {
    await _favoritesRef().doc(productId).set(
      {
        'addedAt': FieldValue.serverTimestamp(),
      }
    );
  }
  Future<void>removeFavorite(String productId)async
  {
    await _favoritesRef().doc(productId).delete();
  }
  Stream<Set<String>>watchFavorites()
  {
    return _favoritesRef().snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet() ,);
  }
  
}