import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';

class BecomeSellerCard extends StatelessWidget {
  const BecomeSellerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: orangedegree,
      child: ListTile(
        contentPadding: const EdgeInsets.all(20).h,
        title: Text(
          'Become a Seller',
          style: AppTextStyles.t_18w700.copyWith(color: Colors.white),
        ),
        subtitle: Text(
          'Start selling your handcrafted products today.',
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
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
// import 'package:handmade_ecommerce_app/core/theme/colors.dart';
// import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';

// class BecomeSellerCard extends StatelessWidget {
//   const BecomeSellerCard({super.key});

//   Future<void> _sendSellerRequest() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final sellerRef =
//         FirebaseFirestore.instance.collection('sellers').doc(user.uid);

//     await sellerRef.set({
//       'name': user.displayName ?? 'Seller',
//       'ownerName': user.displayName ?? 'Seller',
//       'email': user.email ?? '',
//       'phone': user.phoneNumber ?? '',
//       'specialty': 'Handmade Products',
//       'city': '',
//       'country': '',
//       'avatar': '',
//       'badge': 'New Seller',
//       'rating': 0.0,
//       'totalSales': 0,
//       'totalProducts': 0,
//       'walletBalance': 0.0,
//       'commissionRate': 0.10,
//       'isActive': false,
//       'status': 'pending',
//       'submittedAt': FieldValue.serverTimestamp(),
//       'createdAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));

//     Get.snackbar(
//       'Request Sent',
//       'Your seller request is waiting for admin approval.',
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: orangedegree,
//       child: ListTile(
//         onTap: _sendSellerRequest,
//         contentPadding: const EdgeInsets.all(20).h,
//         title: Text(
//           'Become a Seller',
//           style: AppTextStyles.t_18w700.copyWith(color: Colors.white),
//         ),
//         subtitle: Text(
//           'Start selling your handcrafted products today.',
//           style: AppTextStyles.t_14w400.copyWith(color: Colors.white),
//         ),
//         trailing: CustomIconButton(
//           backgroundColor: Colors.white.withValues(alpha: 0.2),
//           icon: Icons.arrow_forward,
//           iconcolor: Colors.white,
//         ),
//       ),
//     );
//   }
// }
