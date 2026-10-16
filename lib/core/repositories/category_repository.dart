import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoply_app/core/model/category/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _firestore
        .collection('categories')
        .get();

    return snapshot.docs.map((doc) {
      return CategoryModel.fromFirestore(
        doc.id,
        doc.data(),
      );
    }).toList();
  }
}