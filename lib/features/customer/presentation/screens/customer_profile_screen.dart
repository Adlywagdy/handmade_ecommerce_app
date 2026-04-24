import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/becomesellercard.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customerdetailsitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/userpofiledetails.dart';
import 'package:hive/hive.dart';

class CustomerProfilesScreen extends StatelessWidget {
  final CustomerModel customer;
  final ValueChanged<int>? onNavigateToTab;
  const CustomerProfilesScreen({
    super.key,
    required this.customer,
    this.onNavigateToTab,
  });

  void _openTab(int tabIndex) {
    if (onNavigateToTab != null) {
      onNavigateToTab!(tabIndex);
      return;
    }

    Get.offNamed(AppRoutes.customerlayout, arguments: tabIndex);
  }

  void _showEditBottomSheet(BuildContext context) {
    final nameController = TextEditingController(text: customer.name);
    final bioController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: customerbackGroundColor,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16.w,
            8.h,
            16.w,
            24.h + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Profile', style: AppTextStyles.t_18w700),
              SizedBox(height: 12.h),
              TextField(
                controller: nameController,
                cursorColor: commonColor,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: subTitleColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: commonColor),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: bioController,
                cursorColor: commonColor,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  labelStyle: TextStyle(color: subTitleColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: commonColor),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: commonColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                HiveHelper.setLoginBox(value:false);
                HiveHelper.clearEmailBox();
                Navigator.of(context).pop(true);
              },
              child: Text('Logout', style: TextStyle(color: redDegree)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          CustomIconButton(
            backgroundColor: Colors.white,
            icon: Icons.more_vert_rounded,
            iconcolor: blackDegree,
          ),
        ],

        title: Text(
          'Profile',
          textAlign: TextAlign.center,
          style: AppTextStyles.t_18w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
          child: Column(
            spacing: 16.h,
            children: [
              SizedBox(height: 16.h),
              UserProfileDetails(customer: customer),

              BecomeSellerCard(),
              Column(
                children: List.generate(_customerDetails.length, (index) {
                  final title = _customerDetails[index]['title'] as String;
                  return CustomerDetailsItem(
                    item: _customerDetails[index],
                    onTap: () {
                      if (title == 'Edit Profile') {
                        _showEditBottomSheet(context);
                        return;
                      }

                      if (title == 'My Orders') {
                        _openTab(3);
                        return;
                      }

                      if (title == 'Favorites') {
                        _openTab(1);
                        return;
                      }

                      if (title == 'Settings') {
                        Get.toNamed(AppRoutes.customerNotifications);
                      }
                    },
                  );
                }),
              ),
              CustomElevatedButton(
                buttonheight: 70.h,
                onPressed: () => _confirmLogout(context),
                bordercolor: redDegree.withValues(alpha: .1),
                buttoncolor: redDegree.withValues(alpha: .07),
                child: Row(
                  children: [
                    Card(
                      elevation: 0,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20.r),
                      ),
                      color: redDegree.withValues(alpha: .1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0).h,
                        child: Icon(Icons.logout, color: redDegree, size: 25.r),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Logout',
                      style: AppTextStyles.t_16w600.copyWith(color: redDegree),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> _customerDetails = [
  {
    'title': 'Edit Profile',
    'subtitle': 'Name, bio ',
    'icon': Icons.edit_outlined,
  },
  {
    'title': 'My Orders',
    'subtitle': 'Track and manage your purchases',
    'icon': Icons.shopping_bag_outlined,
  },
  {
    'title': 'Favorites',
    'subtitle': 'Items you\'ve saved for later',
    'icon': Icons.favorite_border,
  },
  {
    'title': 'Settings',
    'subtitle': 'Notifications and privacy',
    'icon': Icons.settings_outlined,
  },
];
