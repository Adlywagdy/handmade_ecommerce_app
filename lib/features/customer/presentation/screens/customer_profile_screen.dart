import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/becomesellercard.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customerdetailsitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/userpofiledetails.dart';

class CustomerProfilesScreen extends StatelessWidget {
  final CustomerModel customer;
  const CustomerProfilesScreen({super.key, required this.customer});

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
          style: TextStyle(
            color: blackDegree,
            fontSize: 18.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.45,
          ),
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
                  return CustomerDetailsItem(item: _customerDetails[index]);
                }),
              ),
              CustomElevatedButton(
                buttonheight: 70.h,
                onPressed: () {},
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
                      style: TextStyle(
                        color: redDegree,
                        fontSize: 16.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
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
    'subtitle': 'Name, bio, and profile picture',
    'icon': Icons.edit_outlined,
  },
  {
    'title': 'My Orders',
    'subtitle': 'Track and manage your purchases',
    'icon': Icons.shopping_bag_outlined,
  },
  {
    'title': 'favorites',
    'subtitle': 'Items you\'ve saved for later',
    'icon': Icons.notifications_none,
  },
  {
    'title': 'settings',
    'subtitle': 'Notifications and privacy',
    'icon': Icons.settings_outlined,
  },
];
