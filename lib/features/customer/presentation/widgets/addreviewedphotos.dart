import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class AddReviewedPhotos extends StatelessWidget {
  const AddReviewedPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .centerLeft,
      child: Column(
        spacing: 12.h,
        children: [
          Text('Add Photos', style: AppTextStyles.t_14w600),
          CustomPaint(
            painter: DashedBorderPainter(
              color: commonColor.withValues(alpha: .2),
              strokeWidth: 2,
              dashWidth: 6,
              dashSpace: 4,
            ),
            child: GestureDetector(
              onTap: () {}, // should open image picker in real app
              child: SizedBox(
                width: 80.h,
                height: 80.h,

                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: commonColor.withValues(alpha: .4),
                  size: 24.r,
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
