import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../models/sellers_model.dart';
import '../../../widgets/custom_action_button.dart';

class SellerCard extends StatelessWidget {
  final SellerData seller;
  final bool showActions;

  const SellerCard({super.key, required this.seller, this.showActions = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: commonColor.withValues(alpha: 0.10)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  radius: 28.r,
                  backgroundColor: commonColor.withValues(alpha: 0.10),
                  child:SvgPicture.asset('assets/images/unknown_user_icon.svg')
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: blackDegree,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      seller.email,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: subTitleColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      seller.specialty,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: commonColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Submitted: ${seller.submittedDate}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: greyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (seller.badge != null)
                Text(
                  seller.badge!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: seller.badge == 'URGENT' ? redDegree : subTitleColor,
                  ),
                ),
            ],
          ),
          if (showActions) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                ActionButton(
                  label: 'Approve',
                  color: greenDegree,
                  onTap: () {},
                ),
                SizedBox(width: 12.w),
                ActionButton(
                  label: 'Reject',
                  color: redDegree,
                  style: ActionButtonStyle.outlined,
                  onTap: () {},
                ),
              ],
            )
          ],
        ],
      ),
    );
  }
}
