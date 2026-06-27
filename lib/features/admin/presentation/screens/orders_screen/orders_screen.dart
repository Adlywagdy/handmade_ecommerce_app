import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/orders_screen/widget/orders_list.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/custom_searc_bar.dart';
import '../../../cubit/admin_cubit.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Orders',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: blackDegree,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: commonColor,
            unselectedLabelColor: subTitleColor,
            indicatorColor: commonColor,
            overlayColor: WidgetStateProperty.all(
              Colors.grey.withValues(alpha: 0.15),
            ),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: context.l10n.all),
              Tab(text: context.l10n.pending),
              Tab(text: context.l10n.active),
              Tab(text: context.l10n.delivered),
              Tab(text: context.l10n.cancelled),
            ],
          ),
        ),
        body: Column(
          children: [
            CustomSearchBar(
              hintText: context.l10n.searchOrderIdOrName,
              onChanged: (v) => context.read<AdminCubit>().setOrdersQuery(v),
            ),
            Expanded(
              child: BlocBuilder<AdminCubit, AdminState>(
                builder: (context, state) {
                  final cubit = context.read<AdminCubit>();
                  if (cubit.ordersList.isEmpty && state is GetOrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (cubit.ordersList.isEmpty && state is GetOrdersError) {
                    return Center(child: Text(state.error));
                  }
                  return TabBarView(
                    children: List.generate(
                      5,
                      (tab) => OrdersList(orders: cubit.ordersByTab(tab)),
                    ),
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
