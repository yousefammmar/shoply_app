import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoply_app/core/helper/error_handle_helper.dart';
import 'package:shoply_app/core/model/login/request_login.dart';
import 'package:shoply_app/core/model/login/response_login.dart';

class LoginUsecase {
  Future<Either<String, ResponseLogin>> login({
    required RequestLogin requestLogin,
  }) async {
    try {
      final snapshot = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: requestLogin.email ?? '',
        password: requestLogin.password ?? '',
      );

      final user = snapshot.user;
      final snapshotUser = await _getUserinfo(uid: user!.uid);

      final Either<String, ResponseLogin> result = snapshotUser.fold(
        (errorMessage) => Left(errorMessage),
        (responseLogin) => Right(responseLogin),
      );
      return result;
    } on FirebaseAuthException catch (e) {
      final error = ErrorHandleHelper.getCustomErrorMessage(e.code);
      return Left(error);
    }
  }

  Future<Either<String, ResponseLogin>> _getUserinfo({
    required String uid,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .get();

      final data = snapshot.data();
      final currentUser = FirebaseAuth.instance.currentUser;

      final responseLogin = ResponseLogin(
        uid: uid,
        email: data?['email'] ?? currentUser?.email ?? '',
        address: data?['address'] ?? '',
        fullName: data?['fullName'] ?? currentUser?.displayName ?? '',
        userName: data?['userName'] ?? '',
        profileImage: data?['profileImage'],
      );

      return Right(responseLogin);
    } on FirebaseException catch (e) {
      return Left(e.message ?? '');
    }
  }
}
