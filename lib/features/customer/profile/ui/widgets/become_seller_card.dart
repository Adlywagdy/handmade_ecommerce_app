import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/constants/seller_status.dart';
import 'package:handmade_ecommerce_app/core/constants/user_roles.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/custom_icon_button.dart';

class BecomeSellerCard extends StatelessWidget {
  const BecomeSellerCard({super.key});

  void _navigateBasedOnRole() {
    final role = HiveHelper.getRoleBoxValue();
    final status = HiveHelper.getStatusBoxValue();

    if (role == UserRoles.seller && SellerStatus.isApproved(status)) {
      Get.toNamed(AppRoutes.sellerdashboard);
    } else if (role == UserRoles.seller &&
        status == SellerStatus.pending) {
      Get.toNamed(AppRoutes.sellerPending);
    } else {
      Get.toNamed(AppRoutes.sellerregisteation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: orangedegree,
      child: ListTile(
        onTap: _navigateBasedOnRole,
        contentPadding: const EdgeInsets.all(20).h,
        title: Text(
          context.l10n.becomeASeller,
          style: AppTextStyles.t_18w700.copyWith(color: Colors.white),
        ),
        subtitle: Text(
          context.l10n.startSellingYourHandcraftedProductsToday,
          style: AppTextStyles.t_14w400.copyWith(color: Colors.white),
        ),
        trailing: CustomIconButton(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          icon: Icons.arrow_forward,
          iconcolor: Colors.white,
        ),
      ),
    );
  }
}
