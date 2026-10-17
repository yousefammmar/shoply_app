
import 'dart:developer';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class UploadImageService {
  static Future<String?> uplaodImage({
    required File imageFile,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      final originalName =
          imageFile.uri.pathSegments.last.toLowerCase();

      final extension = originalName.contains('.')
          ? originalName.split('.').last
          : '';

      const imageTypes = {
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'png': 'image/png',
        'webp': 'image/webp',
        'gif': 'image/gif',
        'bmp': 'image/bmp',
        'heic': 'image/heic',
        'heif': 'image/heif',
        'avif': 'image/avif',
      };

      final contentType = imageTypes[extension];

      if (contentType == null) {
        throw Exception(
          'Unsupported image format: $extension',
        );
      }

      final imageName =
          '${DateTime.now().microsecondsSinceEpoch}.$extension';

      final imagePath = 'uploads/$imageName';

      log('Uploading image: $imagePath');

      await supabase.storage.from('images').upload(
        imagePath,
        imageFile,
        fileOptions: FileOptions(
          contentType: contentType,
          upsert: false,
        ),
      );

      final imageUrl = supabase.storage
          .from('images')
          .getPublicUrl(imagePath);

      log('Image uploaded successfully: $imageUrl');

      return imageUrl;
    } on StorageException catch (e) {
      log('Supabase Storage Error: ${e.message}');
      log('Status Code: ${e.statusCode}');
      rethrow;
    } catch (e) {
      log('Upload Image Error: $e');
      rethrow;
    }
  }
}
