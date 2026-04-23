import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/models/image_picker_helper.dart';
import 'package:image_picker/image_picker.dart';

class AddReviewedPhotos extends StatefulWidget {
  const AddReviewedPhotos({super.key});

  @override
  State<AddReviewedPhotos> createState() => _AddReviewedPhotosState();
}

class _AddReviewedPhotosState extends State<AddReviewedPhotos> {
  XFile? _selectedImages;
  Uint8List? _webImageBytes;

  @override
  void initState() {
    super.initState();
    _recoverLostData();
  }

  Future<void> _recoverLostData() async {
    final LostDataResponse response = await imagePickerHelper.recoverLostData();
    if (response.isEmpty) return;

    final XFile? recoveredFile = response.files?.isNotEmpty == true
        ? response.files!.first
        : null;

    if (recoveredFile != null) {
      await _setSelectedImage(recoveredFile);
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.exception?.message ?? 'Failed to recover image.',
        ),
        backgroundColor: redDegree,
      ),
    );
  }

  Future<void> _setSelectedImage(XFile image) async {
    final Uint8List? bytes = kIsWeb
        ? await imagePickerHelper.xFileToBytes(image)
        : null;

    if (!mounted) return;
    setState(() {
      _selectedImages = image;
      _webImageBytes = bytes;
    });
  }

  Future<void> _pickImage() async {
    try {
      final List<XFile>? pickedImages = await imagePickerHelper
          .pickMultipleImages();

      if (pickedImages == null || pickedImages.isEmpty) return;
      await _setSelectedImage(pickedImages.first);
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Image picker is unavailable now. Restart the app and try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .centerLeft,
      child: Column(
        spacing: 12.h,
        children: [
          Text('Add Photos', style: AppTextStyles.t_14w600),
          GestureDetector(
            onTap: _pickImage,
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: commonColor.withValues(alpha: .2),
                strokeWidth: 2,
                dashWidth: 6,
                dashSpace: 4,
              ),
              child: SizedBox(
                width: 80.h,
                height: 80.h,
                child: _selectedImages == null
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        color: commonColor.withValues(alpha: .4),
                        size: 24.r,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: kIsWeb
                            ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                            : Image.file(
                                File(_selectedImages!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.borderRadius = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rRect);

    final dashedPath = _createDashedPath(path);

    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source) {
    final Path dashedPath = Path();

    for (PathMetric metric in source.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final next = distance + dashWidth;

        dashedPath.addPath(metric.extractPath(distance, next), Offset.zero);

        distance = next + dashSpace;
      }
    }

    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
