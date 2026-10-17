import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoply_app/core/model/product/product_model.dart';

class ProductsRepo 
{
  final FirebaseFirestore _fireStore= FirebaseFirestore.instance;

  Future<Either<String, List<ProductModel>>> getProducts() async
  {
    try
    {
      final snapshot= await _fireStore
      .collection('products')
      .get();
      final products = snapshot.docs.map((doc)
      {
        return ProductModel.fromFirestore(doc.id, doc.data());
      }
      ).toList();
      return Right(products);
    } on FirebaseException catch (e)
    {
      return Left(e.message?? 'Failed to fetch product');
    }
    catch (e)
    {
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, List<ProductModel>>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      final products = snapshot.docs.map((doc) {
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