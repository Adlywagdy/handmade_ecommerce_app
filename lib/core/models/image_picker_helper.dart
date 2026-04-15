import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Helper class for image picking operations across the app
class ImagePickerHelper {
  static final ImagePickerHelper _instance = ImagePickerHelper._internal();

  final ImagePicker _picker = ImagePicker();

  ImagePickerHelper._internal();

  factory ImagePickerHelper() {
    return _instance;
  }

  /// Pick a single image from device gallery
  /// Returns XFile on success, null if user cancels
  /// Throws PlatformException if picker fails
  Future<XFile?> pickImageFromGallery({
    int imageQuality = 80,
    double maxWidth = 1200,
  }) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
      );
      return pickedImage;
    } catch (e) {
      rethrow;
    }
  }

  /// Pick multiple images from gallery
  /// Returns list of XFile on success
  /// Throws PlatformException if picker fails
  Future<List<XFile>?> pickMultipleImages({
    int imageQuality = 80,
    double maxWidth = 1200,
  }) async {
    try {
      final List<XFile> pickedImages = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
      );
      return pickedImages.isEmpty ? null : pickedImages;
    } catch (e) {
      rethrow;
    }
  }

  /// Recover images that were picked but not processed due to app interruption
  /// Returns LostDataResponse containing recovered files or exception
  Future<LostDataResponse> recoverLostData() async {
    return await _picker.retrieveLostData();
  }

  /// Convert XFile to bytes (useful for web preview)
  /// Returns bytes on success, null if fails
  Future<Uint8List?> xFileToBytes(XFile file) async {
    try {
      return await file.readAsBytes();
    } catch (e) {
      return null;
    }
  }

  /// Get file extension from XFile
  String getFileExtension(XFile file) {
    final name = file.name.split('.');
    return name.isNotEmpty ? name.last : 'jpg';
  }

  /// Get file name from XFile
  String getFileName(XFile file) {
    return file.name;
  }

  /// Get file size in bytes
  Future<int?> getFileSizeBytes(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      return bytes.length;
    } catch (e) {
      return null;
    }
  }
}

// Singleton instance for easy access
final imagePickerHelper = ImagePickerHelper();
