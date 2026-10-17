
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shoply_app/core/model/signup/request_signup.dart';
import 'package:shoply_app/core/service/upload_image_service.dart';

class SignupUsecase {
  Future<Either<String, bool>> signup({
    required String password,
    required RequestSignup requestSignup,
    required File? image,
  }) async {
    try {
      // 1. Create Firebase Authentication account
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: requestSignup.email?.trim() ?? '',
            password: password,
          );

      final user = credential.user;

      if (user == null) {
        return const Left('Failed to create user account');
      }

      // 2. Upload profile image to Supabase
      final imageUrl = await _uploadImage(image: image);

      // 3. Save user information in Firestore
      final saveResult = await _saveUserData(
        requestSignup: RequestSignup(
          email: requestSignup.email?.trim(),
          fullName: requestSignup.fullName?.trim(),
          userName: requestSignup.userName?.trim(),
          address: requestSignup.address?.trim(),
          uid: user.uid,
          profileImage: imageUrl,
        ),
      );

      if (saveResult.isLeft()) {
        return saveResult;
      }

      // 4. Send email verification
      final verificationResult = await _sendEmailVerification(
        userCredential: credential,
      );

      if (verificationResult.isLeft()) {
        return verificationResult;
      }

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error: ${e.message}');
      return Left(
        e.message ?? 'Authentication failed',
      );
    } on StorageException catch (e) {
      log('Supabase Storage Error: ${e.message}');
      return Left(
        'Profile image upload failed: ${e.message}',
      );
    } on FirebaseException catch (e) {
      log('Firebase Error: ${e.message}');
      return Left(
        e.message ?? 'Firebase operation failed',
      );
    } catch (e) {
      log('Signup Error: $e');
      return Left('Sign up failed: $e');
    }
  }

  // ================= IMAGE UPLOAD =================

  Future<String?> _uploadImage({
    required File? image,
  }) async {
    if (image == null) {
      return null;
    }

    if (!await image.exists()) {
      throw Exception('Selected image does not exist');
    }

    final imageUrl = await UploadImageService.uplaodImage(
      imageFile: image,
    );

    if (imageUrl == null ||
        !imageUrl.startsWith('https://')) {
      throw Exception('Invalid profile image URL');
    }

    return imageUrl;
  }

  // ================= EMAIL VERIFICATION =================

  Future<Either<String, bool>> _sendEmailVerification({
    required UserCredential userCredential,
  }) async {
    try {
      final user = userCredential.user;

      if (user == null) {
        return const Left('User not found');
      }

      // Use Firebase's default verification link
      await user.sendEmailVerification();

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      log('Email Verification Error: ${e.message}');

      return Left(
        e.message ?? 'Failed to send verification email',
      );
    } catch (e) {
      log('Email Verification Error: $e');

      return Left(
        'Failed to send verification email: $e',
      );
    }
  }

  // ================= FIRESTORE =================

  Future<Either<String, bool>> _saveUserData({
    required RequestSignup requestSignup,
  }) async {
    try {
      final uid = requestSignup.uid;

      if (uid == null || uid.isEmpty) {
        return const Left('User UID is missing');
      }

      await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .set(requestSignup.toJson());

      return const Right(true);
    } on FirebaseException catch (e) {
      log('Firestore Error: ${e.message}');

      return Left(
        e.message ?? 'Failed to save user information',
      );
    }
  }
}
