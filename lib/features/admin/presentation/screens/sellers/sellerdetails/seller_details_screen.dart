import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../cubit/admin_cubit.dart';
import 'widgets/seller_details_body.dart';

class SellerDetailsScreen extends StatelessWidget {
  final String sellerId;

  const SellerDetailsScreen({super.key, required this.sellerId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final cubit = context.read<AdminCubit>();
        final seller = cubit.sellerById(sellerId);

        if (seller == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Seller')),
            body: const Center(child: Text('Seller not found')),
          );
        }

        return Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Seller Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: blackDegree,
              ),
            ),
            centerTitle: true,
          ),
          body: SellerDetailsBody(seller: seller, cubit: cubit),
        );
      },
    );
  }
}
