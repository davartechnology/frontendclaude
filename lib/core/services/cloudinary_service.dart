import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../config/env.dart';
import '../utils/logger.dart';

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  final Dio _dio = Dio();

  Future<String?> uploadVideo(dynamic file, {
    Function(double)? onProgress,
    String? fileName,
  }) async {
    try {
      String actualFileName;
      MultipartFile multipartFile;

      if (file is File) {
        // Mobile: use file path
        actualFileName = fileName ?? file.path.split('/').last;
        multipartFile = await MultipartFile.fromFile(file.path, filename: actualFileName);
      } else if (file is Uint8List) {
        // Web: use bytes
        actualFileName = fileName ?? 'video.mp4';
        multipartFile = MultipartFile.fromBytes(file, filename: actualFileName);
      } else {
        throw Exception('Unsupported file type');
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
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

  Future<String?> uploadImage(dynamic file, {String? fileName}) async {
    try {
      String actualFileName;
      MultipartFile multipartFile;

      if (file is File) {
        // Mobile: use file path
        actualFileName = fileName ?? file.path.split('/').last;
        multipartFile = await MultipartFile.fromFile(file.path, filename: actualFileName);
      } else if (file is Uint8List) {
        // Web: use bytes
        actualFileName = fileName ?? 'image.jpg';
        multipartFile = MultipartFile.fromBytes(file, filename: actualFileName);
      } else {
        throw Exception('Unsupported file type');
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
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