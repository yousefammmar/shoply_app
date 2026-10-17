import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersRepo 
{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String,dynamic>> _ordersRef()
  {
    final user=_auth.currentUser;
    if(user==null)
    {
      throw StateError('User is not logged in.');
    }
    return _firestore
    .collection('User')
    .doc(user.uid)
    .collection('orders');
  }
  Future<String> createOrder(
    {
      required List<Map<String, dynamic>> items, required double total,
    }
  ) async
  {
    final orederRef= _ordersRef().doc();
    await orederRef.set({
      'items': items,
      'total': total,
      'status': 'placed',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return orederRef.id;
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> watchOrders() {
    return _ordersRef()
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}