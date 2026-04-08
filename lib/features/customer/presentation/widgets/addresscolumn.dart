import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customfeaturerow.dart';

class AddressColumn extends StatelessWidget {
  const AddressColumn({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        CustomFeatureRow(
          title: 'Delivery Address',
          buttontext: 'Change',
          buttontextstyle: AppTextStyles.t_16w600.copyWith(color: commonColor),
        ),
        Card(
          color: commonColor.withValues(alpha: .05),
          elevation: 0,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: BorderSide(
              color: commonColor.withValues(alpha: .1),
              width: 1.5,
            ),
          ),
          child: ListTile(
            leading: Card(
              color: Colors.white,

              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 12.h,
                  right: 12,
                  left: 12,
                  top: 4.h,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: commonColor,
                  size: 26.r,
                ),
              ),
            ),
            title: Text(
              order.customer.address?.addresstitle ?? "Home",
              style: AppTextStyles.t_16w600.copyWith(color: blackDegree),
            ),
            subtitle: Text(
              order.customer.address?.addressdescription ??
                  "123 Main St, City, Country",
              style: AppTextStyles.t_14w400.copyWith(
                color: blackDegree.withValues(alpha: .7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
