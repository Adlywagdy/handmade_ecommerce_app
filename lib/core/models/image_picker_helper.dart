import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Singleton helper for image picking operations.
class ImagePickerHelper {
  ImagePickerHelper._internal();
  static final ImagePickerHelper _instance = ImagePickerHelper._internal();
  factory ImagePickerHelper() => _instance;

  final ImagePicker _picker = ImagePicker();

  /// Pick a single image from gallery.
  Future<XFile?> pickImageFromGallery({
    int imageQuality = 80,
    double maxWidth = 1200,
  }) async {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
    );
  }

  /// Pick multiple images from gallery.
  Future<List<XFile>?> pickMultipleImages({
    int imageQuality = 80,
    double maxWidth = 1200,
  }) async {
    final picked = await _picker.pickMultiImage(
      imageQuality: imageQuality,
      maxWidth: maxWidth,
    );
    return picked.isNotEmpty ? picked : null;
  }

  /// Convert XFile to bytes.
  Future<Uint8List?> xFileToBytes(XFile file) async {
    try {
      return await file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  /// Recover lost data from app interruption.
  Future<LostDataResponse> recoverLostData() async {
    return _picker.retrieveLostData();
  }
}

/// Convenience singleton instance.
final imagePickerHelper = ImagePickerHelper();
