import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:handmade_ecommerce_app/core/constants/cloudinary_constants.dart';

class CloudinaryService {
  CloudinaryService._();

  static final CloudinaryService _instance = CloudinaryService._();
  factory CloudinaryService() => _instance;

  final Dio _dio = Dio();

  Future<String> uploadImage(File file) async {
    final fileName = file.uri.pathSegments.last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      'upload_preset': CloudinaryConstants.uploadPreset,
    });

    final response = await _dio.post(
      CloudinaryConstants.uploadUrl,
      data: formData,
    );

    if (response.statusCode == 200) {
      return response.data['secure_url'] as String;
    } else {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
  }

  Future<String> uploadImageFromBytes(Uint8List bytes, String fileName) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
      'upload_preset': CloudinaryConstants.uploadPreset,
    });

    final response = await _dio.post(
      CloudinaryConstants.uploadUrl,
      data: formData,
    );

    if (response.statusCode == 200) {
      return response.data['secure_url'] as String;
    } else {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
  }

  Future<List<String>> uploadImages(List<File> files) async {
    final urls = <String>[];
    for (final file in files) {
      final url = await uploadImage(file);
      urls.add(url);
    }
    return urls;
  }
}
