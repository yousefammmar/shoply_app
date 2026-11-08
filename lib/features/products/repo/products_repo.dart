
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoply_app/core/model/product/product_model.dart';

class ProductsRepo {
  final FirebaseFirestore _fireStore =
      FirebaseFirestore.instance;

  bool _isVisible(Map<String, dynamic> data) {
    // Old products without isActive remain visible.
    return data['isActive'] != false;
  }

  Future<Either<String, List<ProductModel>>> getProducts() async {
    try {
      final snapshot = await _fireStore
          .collection('products')
          .get();

      final products = snapshot.docs
          .where((doc) => _isVisible(doc.data()))
          .map((doc) {
        return ProductModel.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();

      return Right(products);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Failed to fetch products');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, List<ProductModel>>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      final snapshot = await _fireStore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      final products = snapshot.docs
          .where((doc) => _isVisible(doc.data()))
          .map((doc) {
        return ProductModel.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();

      return Right(products);
    } on FirebaseException catch (e) {
      return Left(
        e.message ?? 'Failed to load category products',
      );
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }
}
