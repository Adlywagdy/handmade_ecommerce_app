import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
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
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.admSeller),
            ),
            body: Center(
              child: Text(AppLocalizations.of(context)!.admSellerNotFound),
            ),
          );
        }

        return Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context)!.admSellerDetails,
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
