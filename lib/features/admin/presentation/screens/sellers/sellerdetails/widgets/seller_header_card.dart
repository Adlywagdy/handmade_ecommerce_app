import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/colors.dart';
import '../../../../../models/sellers_model.dart';

// Top card on the seller details page.
// Shows the avatar, name, specialty and a colored status badge.
class SellerHeaderCard extends StatelessWidget {
  final SellerData seller;

  const SellerHeaderCard({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: commonColor.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: commonColor.withValues(alpha: 0.10),
            child: Icon(Icons.person, color: commonColor, size: 32.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(child: _SellerHeaderInfo(seller: seller)),
        ],
      ),
    );
  }
}

// The name + specialty + status badge column on the right of the avatar.
class _SellerHeaderInfo extends StatelessWidget {
  final SellerData seller;

  const _SellerHeaderInfo({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          seller.name,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: blackDegree,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          seller.specialty,
          style: TextStyle(
            fontSize: 13.sp,
            color: commonColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        _SellerStatusBadge(status: seller.status),
      ],
    );
  }
}

// Small colored pill showing the seller status (PENDING / APPROVED / REJECTED).
class _SellerStatusBadge extends StatelessWidget {
  final SellerStatus status;

  const _SellerStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = _colorForStatus(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Color _colorForStatus(SellerStatus status) {
    switch (status) {
      case SellerStatus.pending:
        return const Color(0xFFD97706);
      case SellerStatus.approved:
        return const Color(0xFF07880E);
      case SellerStatus.rejected:
        return const Color(0xFFD32F2F);
    }
  }
}
