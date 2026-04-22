import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/custom_searc_bar.dart';
import '../../../cubit/admin_cubit.dart';
import '../../../models/sellers_model.dart';
import 'sellerdetails/seller_details_screen.dart';
import 'widget/seller_card.dart';

class SellersScreen extends StatelessWidget {
  const SellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Seller Approvals',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: blackDegree,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: commonColor,
            unselectedLabelColor: subTitleColor,
            indicatorColor: commonColor,
            overlayColor:
                WidgetStateProperty.all(Colors.grey.withValues(alpha: 0.15)),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
                TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: Column(
          children: [
            CustomSearchBar(
              hintText: 'Search sellers...',
              onChanged: (v) => context.read<AdminCubit>().setSellersQuery(v),
            ),
            Expanded(
              child: BlocBuilder<AdminCubit, AdminState>(
                builder: (context, state) {
                  final cubit = context.read<AdminCubit>();
                  if (cubit.sellersList.isEmpty && state is GetSellersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (cubit.sellersList.isEmpty && state is GetSellersError) {
                    return Center(child: Text(state.error));
                  }
                  return TabBarView(
                    children: [
                      _SellersList(
                        sellers: cubit.sellersByStatus(SellerStatus.pending),
                      ),
                      _SellersList(
                        sellers: cubit.sellersByStatus(SellerStatus.approved),
                        showActions: false,
                      ),
                      _SellersList(
                        sellers: cubit.sellersByStatus(SellerStatus.rejected),
                        showActions: false,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////
class _SellersList extends StatelessWidget {
  final List<SellerData> sellers;
  final bool showActions;

  const _SellersList({required this.sellers, this.showActions = true});

  @override
  Widget build(BuildContext context) {
    if (sellers.isEmpty) {
      return Center(
        child: Text(
          'No sellers found',
          style: TextStyle(fontSize: 14.sp, color: subTitleColor),
        ),
      );
    }
    final cubit = context.read<AdminCubit>();
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: sellers.length,
      itemBuilder: (context, index) {
        final seller = sellers[index];
        return SellerCard(
          seller: seller,
          showActions: showActions,
          isProcessing: cubit.isProcessing(seller.id),
          onApprove: () => cubit.approveSeller(seller.id),
          onReject: () => cubit.rejectSeller(seller.id),
          onPreview: () => Get.to(() => BlocProvider.value(value: cubit, child: SellerDetailsScreen(sellerId: seller.id))),
        );
      },
    );
  }
}
