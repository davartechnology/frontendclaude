import 'dart:io';
import 'package:dio/dio.dart';
import '../../config/env.dart';
import '../utils/logger.dart';

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  final Dio _dio = Dio();

  Future<String?> uploadVideo(File file, {
    Function(double)? onProgress,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'upload_preset': Env.cloudinaryUploadPreset,
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/${Env.cloudinaryCloudName}/video/upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null) {
            final progress = sent / total;
            onProgress(progress);
          }
        },
      );

      final videoUrl = response.data['secure_url'] as String;
      Logger.info('Video uploaded: $videoUrl');
      return videoUrl;
    } catch (e) {
      Logger.error('Video upload failed', e);
      return null;
    }
  }

  Future<String?> uploadImage(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'upload_preset': Env.cloudinaryUploadPreset,
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/${Env.cloudinaryCloudName}/image/upload',
        data: formData,
      );

      final imageUrl = response.data['secure_url'] as String;
      Logger.info('Image uploaded: $imageUrl');
      return imageUrl;
    } catch (e) {
      Logger.error('Image upload failed', e);
      return null;
    }
  }

  Future<bool> deleteResource(String publicId, {bool isVideo = true}) async {
    try {
      final type = isVideo ? 'video' : 'image';
      await _dio.post(
        'https://api.cloudinary.com/v1_1/${Env.cloudinaryCloudName}/$type/destroy',
        data: {'public_id': publicId},
      );
      Logger.info('Resource deleted: $publicId');
      return true;
    } catch (e) {
      Logger.error('Resource deletion failed', e);
      return false;
    }
  }
}